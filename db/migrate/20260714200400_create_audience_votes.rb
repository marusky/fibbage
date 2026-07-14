class CreateAudienceVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :audience_votes do |t|
      t.references :audience_player, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
