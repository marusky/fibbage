class Player < ApplicationRecord
  has_many :answers
  has_many :votes

  validates :name, presence: true
end
