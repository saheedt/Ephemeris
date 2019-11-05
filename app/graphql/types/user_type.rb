module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :screen_name, String, null: false
    field :name, String, null: true
    field :password_digest, String, null: true
  end
end
