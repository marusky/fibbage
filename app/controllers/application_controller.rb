class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_game

  def current_player
    @current_player ||= Player.find_by(id: cookies.encrypted[:pid])
  end

  private
    def set_game
      @game = Game.first
    end
end
