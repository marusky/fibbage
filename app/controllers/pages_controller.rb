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

  def game
    return redirect_to new_player_url unless current_player

    @question = @game.current_question
    @answer = current_player.answers.find_by(question: @question)
    @vote = current_player.votes.joins(answer: :question).find_by(answer: { question: @question })
    @other_answers = @game.current_question.answers.where("player_id IS NULL OR player_id != ?", current_player.id).shuffle
  end

  private
    def build_reveal(question)
      answers = question.answers.includes(:player, votes: :player).order(:id).to_a
      truth = answers.find(&:truth?)
      voted_lies = answers.reject(&:truth?).select { |answer| answer.votes.any? }.sort_by { |answer| answer.votes.size }

      details = (voted_lies + [ truth ]).index_by(&:id).transform_values do |answer|
        {
          author: answer.truth? ? nil : (answer.our_lie? ? "Our Lie" : answer.player.name),
          voters: answer.votes.map { |vote| vote.player.name },
          points: answer.votes.sum(&:points)
        }
      end

      { answers: answers, order: voted_lies.map(&:id) + [ truth.id ], details: details }
    end
end
