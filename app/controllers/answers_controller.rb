class AnswersController < ApplicationController
  def create
    question = @game.current_question

    return redirect_to game_url unless question.state_open?
    return redirect_to game_url if question.answerable_until && Time.current > question.answerable_until

    @answer = current_player.answers.build(answer_params.merge(question: question))

    return redirect_to game_url unless @answer.valid?

    @answer.save!
    question.close! if question.all_answered?

    redirect_to game_url
  end

  private
    def answer_params
      params.expect(answer: :text)
    end
end
