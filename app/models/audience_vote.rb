class AudienceVote < ApplicationRecord
  belongs_to :audience_player
  belongs_to :answer
end
