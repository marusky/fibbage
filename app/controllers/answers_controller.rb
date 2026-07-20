class AnswersController < ApplicationController
  def create
    question = @game.current_question

    return redirect_to game_url unless question.state_open?
    return redirect_to game_url if question.answerable_until && Time.current > question.answerable_until

    @answer = current_player.answers.build(answer_params.merge(question: question))
    @answer.valid?

    return redirect_to game_url if @answer.errors[:player_id].any?

    if @answer.errors.any?
      @other_answers = question.answers.where("player_id IS NULL OR player_id != ?", current_player.id).shuffle
      return render "games/show", status: :unprocessable_entity
    end

    @answer.save!
    question.close! if question.all_answered?

    redirect_to game_url
  end

  private
    def answer_params
      params.expect(answer: :text)
    end
end
