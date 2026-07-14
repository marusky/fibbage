class Answer < ApplicationRecord
  belongs_to :player, optional: true
  belongs_to :question
  has_many :votes
  has_many :audience_votes

  validates :text, presence: true
  validates :player_id, uniqueness: { scope: :question_id }, allow_nil: true
end
