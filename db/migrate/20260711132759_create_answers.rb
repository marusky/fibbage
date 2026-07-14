class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.references :player
      t.references :question, null: false, foreign_key: true
      t.string :text, null: false
      t.boolean :our_lie, null: false, default: false
      t.boolean :truth, null: false, default: false

      t.timestamps
    end
  end
end
