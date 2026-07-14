class AudienceChoicesController < ApplicationController
  def create
    question = @game.current_question

    return redirect_to audience_url unless question.state_open?
    return redirect_to audience_url if question.answerable_until && Time.current > question.answerable_until

    @audience_choice = current_audience_player.audience_choices.build(audience_choice_params)

    return redirect_to audience_url unless @audience_choice.valid?

    @audience_choice.save!

    redirect_to audience_url
  end

  private
    def audience_choice_params
      params.expect(audience_choice: :lie_id)
    end
end
