class Answer < ApplicationRecord
  belongs_to :player, optional: true
  belongs_to :question
  has_many :votes
  has_many :audience_votes

  validates :text, presence: true
  validates :player_id, uniqueness: { scope: :question_id }, allow_nil: true
  validate :not_the_truth, unless: -> { truth? || our_lie? || audience_lie? }

  private
    def not_the_truth
      return if text.blank? || question.nil?

      truth_answer = question.answers.find_by(truth: true)
      return if truth_answer.nil?

      if text.strip.casecmp?(truth_answer.text.strip)
        errors.add(:text, "that's the right answer! quickly think of something else")
      end
    end
end
