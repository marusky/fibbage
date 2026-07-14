class CreateAudienceChoices < ActiveRecord::Migration[8.0]
  def change
    create_table :audience_choices do |t|
      t.references :audience_player, null: false, foreign_key: true
      t.references :lie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
