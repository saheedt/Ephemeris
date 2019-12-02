module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::Users::CreateUser
    field :user_login, mutation: Mutations::Users::UserLogin
  end
end
