class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.references :topic, foreign_key: true
      t.uuid :uuid, null: false, index: { unique: true }
      t.string :title, null: false, default: "Untitled"
      t.text :content, null: false, default: ""
    end
  end
end
