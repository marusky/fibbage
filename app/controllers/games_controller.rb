class GamesController < ApplicationController
  def show
    return redirect_to new_player_url unless current_player

    @question = @game.current_question
    @answer = current_player.answers.find_by(question: @question)
    @vote = current_player.votes.joins(answer: :question).find_by(answer: { question: @question })
    @other_answers = @game.current_question.answers.where("player_id IS NULL OR player_id != ?", current_player.id).shuffle
  end

  def start
    @game.update!(on: true)

    redirect_to admin_url
  end

  def next_question
    @game.next_question!

    redirect_to admin_url
  end

  def reset
    Rails.application.load_seed

    redirect_to admin_url
  end
end
