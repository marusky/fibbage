class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.string :state, null: false, default: "initial"
      t.text :question, null: false
      t.datetime :answerable_until
      t.integer :order
      t.integer :points, null: false, default: 0
      t.belongs_to :game

      t.timestamps
    end
  end
end
