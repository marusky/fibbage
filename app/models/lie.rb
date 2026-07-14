class Lie < ApplicationRecord
  belongs_to :question
  has_many :audience_choices

  scope :audience, -> { where(audience: true) }
  scope :our, -> { where(audience: false) }
end
