class AudiencePlayer < ApplicationRecord
  has_many :audience_choices
  has_many :audience_votes

  validates :name, presence: true
end
