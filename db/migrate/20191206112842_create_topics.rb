class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.references :user, foreign_key: true
      t.string :title, null: false, default: "Untitled"
      t.uuid :uuid, null: false, index: { unique: true }
      t.boolean :is_public, null: false, default: false

      t.timestamps
    end
  end
end
