class Vote < ApplicationRecord
  belongs_to :player
  belongs_to :answer

  before_create :add_points
  validate :one_vote_per_question

  private
    def one_vote_per_question
      return if player_id.blank? || answer.nil?

      already_voted = Vote.joins(:answer)
                          .where(player_id: player_id, answers: { question_id: answer.question_id })
                          .where.not(id: id)
                          .exists?

      errors.add(:base, "already voted for this question") if already_voted
    end

    def add_points
      self.points =
        if answer.truth?
          answer.question.points
        elsif answer.our_lie? || answer.audience_lie?
          0
        else
          answer.question.points / 2
        end
    end
end
