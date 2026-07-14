class AddAudienceLieToAnswers < ActiveRecord::Migration[8.0]
  def change
    add_column :answers, :audience_lie, :boolean, default: false, null: false
  end
end
