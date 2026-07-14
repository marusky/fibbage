class AudiencePlayersController < ApplicationController
  def new
    @audience_player = AudiencePlayer.new
  end

  def create
    @audience_player = AudiencePlayer.new(audience_player_params)

    if @audience_player.save
      cookies.encrypted[:apid] = @audience_player.id

      redirect_to audience_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def audience_player_params
      params.expect(audience_player: :name)
    end
end
