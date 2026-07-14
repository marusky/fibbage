class AddPointsToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :points, :integer, null: false, default: 0
  end
end
