class Current < ActiveSupport::CurrentAttributes
  def game
    Game.first
  end

  def question
    game.current_question
  end
end
