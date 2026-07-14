class CreateAudiencePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :audience_players do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
