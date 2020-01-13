class AddIsPublicToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :is_public, :boolean, null: false, default: false
  end
end
