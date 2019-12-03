module Types
  class UserType < Types::BaseObject
    field :uuid, String, null: false
    field :email, String, null: false
    field :screen_name, String, null: false
    field :name, String, null: true
  end
end
