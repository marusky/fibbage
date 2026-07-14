class Vote < ApplicationRecord
  belongs_to :player
  belongs_to :answer

  before_create :add_points

  private
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
