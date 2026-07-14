class AudienceVotesController < ApplicationController
  def create
    @audience_vote = current_audience_player.audience_votes.build(audience_vote_params)

    return redirect_to audience_url unless @audience_vote.valid?

    @audience_vote.save!

    redirect_to audience_url
  end

  private
    def audience_vote_params
      params.expect(audience_vote: :answer_id)
    end
end
