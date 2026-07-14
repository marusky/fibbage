class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.boolean :on, null: false, default: false
      t.string :code, null: false
      t.integer :question_number, null: false, default: 1

      t.timestamps
    end
  end
end
