class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.belongs_to :player, null: false, foreign_key: true
      t.belongs_to :answer, null: false, foreign_key: true
      t.integer :points, null: false, default: 0

      t.timestamps
    end
  end
end
