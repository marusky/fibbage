class AudienceChoicesController < ApplicationController
  def create
    question = @game.current_question

    return redirect_to audience_url if question.answerable_until && Time.current > question.answerable_until

    current_audience_player.audience_choices.create!(audience_choice_params)

    redirect_to audience_url
  end

  private
    def audience_choice_params
      params.expect(audience_choice: :lie_id)
    end
end
