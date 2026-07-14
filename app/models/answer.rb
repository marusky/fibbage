class Answer < ApplicationRecord
  belongs_to :player, optional: true
  belongs_to :question
  has_many :votes
  has_many :audience_votes

  validates :text, presence: true
end
