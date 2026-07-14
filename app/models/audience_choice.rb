class AudienceChoice < ApplicationRecord
  belongs_to :audience_player
  belongs_to :lie

  validate :one_choice_per_question

  private
    def one_choice_per_question
      return if audience_player_id.blank? || lie.nil?

      already_chosen = AudienceChoice.joins(:lie)
                                      .where(audience_player_id: audience_player_id, lies: { question_id: lie.question_id })
                                      .where.not(id: id)
                                      .exists?

      errors.add(:base, "already chosen for this question") if already_chosen
    end
end
