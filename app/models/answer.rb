class Answer < ApplicationRecord
  belongs_to :player, optional: true
  belongs_to :question
  has_many :votes

  validates :text, presence: true
end
