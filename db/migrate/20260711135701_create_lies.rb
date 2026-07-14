class CreateLies < ActiveRecord::Migration[8.0]
  def change
    create_table :lies do |t|
      t.string :text
      t.boolean :audience
      t.belongs_to :question

      t.timestamps
    end
  end
end
