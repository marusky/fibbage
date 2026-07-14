class Lie < ApplicationRecord
  belongs_to :question

  scope :audience, -> { where(audience: true) }
  scope :our, -> { where(audience: false) }
end
