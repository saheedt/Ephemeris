class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto'

    create_table :users do |t|
      t.string :screen_name, null: false, index: { unique: true }
      t.string :name
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.uuid :uuid, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
