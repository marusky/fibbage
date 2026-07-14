class VotesController < ApplicationController
  def create
    @vote = Vote.new(vote_params)

    @vote.save!
    redirect_to game_url
  end

  private
    def vote_params
      params.expect(vote: :answer_id).merge(player: current_player)
    end
end
