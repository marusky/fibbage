class PagesController < ApplicationController
  def tv
    @question = @game.current_question

    if @question.state_evaluated?
      @reveal = build_reveal(@question)
      @leaderboard = Player.order(points: :desc, name: :asc)
    end
  end

  def admin
  end

  def audience
    return redirect_to new_audience_player_url unless current_audience_player

    @question = @game.current_question
    @audience_choice = current_audience_player.audience_choices.joins(:lie).find_by(lies: { question_id: @question.id })
    @audience_vote = current_audience_player.audience_votes.joins(:answer).find_by(answers: { question_id: @question.id })
    @voting_answers = @question.answers.where(audience_lie: false).order(:id) if @question.state_voting?
  end

  private
    def build_reveal(question)
      answers = question.answers.includes(:player, votes: :player, audience_votes: :audience_player).order(:id).to_a
      truth = answers.find(&:truth?)
      voted_lies = answers.reject(&:truth?).select { |answer| answer.votes.any? || answer.audience_votes.any? }
                           .sort_by { |answer| answer.votes.size + answer.audience_votes.size }

      total_audience_votes = answers.sum { |answer| answer.audience_votes.size }

      details = (voted_lies + [ truth ]).index_by(&:id).transform_values do |answer|
        audience_points =
          if total_audience_votes.zero? || answer.player.nil?
            0
          else
            (Question::AUDIENCE_POINTS_POOL * answer.audience_votes.size / total_audience_votes.to_f).round
          end

        {
          author: answer.truth? ? nil : (answer.our_lie? ? "Our Lie" : (answer.audience_lie? ? "Audience" : answer.player.name)),
          voters: answer.votes.map { |vote| vote.player.name },
          points: answer.votes.sum(&:points),
          audience_count: answer.audience_votes.size,
          audience_percent: total_audience_votes.zero? ? 0 : (answer.audience_votes.size * 100.0 / total_audience_votes).round,
          audience_points: audience_points
        }
      end

      { answers: answers, order: voted_lies.map(&:id) + [ truth.id ], details: details }
    end
end
