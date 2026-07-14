class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)

    if @player.save
      cookies.encrypted[:pid] = @player.id

      redirect_to game_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def player_params
      params.expect(player: :name)
    end
end
