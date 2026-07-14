class AudienceVote < ApplicationRecord
  belongs_to :audience_player
  belongs_to :answer

  validate :one_vote_per_question

  private
    def one_vote_per_question
      return if audience_player_id.blank? || answer.nil?

      already_voted = AudienceVote.joins(:answer)
                                   .where(audience_player_id: audience_player_id, answers: { question_id: answer.question_id })
                                   .where.not(id: id)
                                   .exists?

      errors.add(:base, "already voted for this question") if already_voted
    end
end
