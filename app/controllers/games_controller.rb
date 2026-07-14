class GamesController < ApplicationController
  def start
    @game.update!(on: true)

    redirect_to admin_url
  end

  def next_question
    @game.next_question!

    redirect_to admin_url
  end
end
