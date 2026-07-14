class QuestionsController < ApplicationController
  before_action :set_question

  def open
    @question.open!

    redirect_to admin_url
  end

  def open_voting
    @question.open_voting!

    redirect_to admin_url
  end

  def evaluate
    @question.evaluate!

    redirect_to admin_url
  end

  private
    def set_question
      @question = @game.current_question
    end
end
