class AudienceVotesController < ApplicationController
  def create
    current_audience_player.audience_votes.create!(audience_vote_params)

    redirect_to audience_url
  end

  private
    def audience_vote_params
      params.expect(audience_vote: :answer_id)
    end
end
