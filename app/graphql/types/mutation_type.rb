module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::Users::CreateUser
    field :user_login, mutation: Mutations::Users::UserLogin
    field :create_topic, mutation: Mutations::Topics::CreateTopic
    field :create_post, mutation: Mutations::Posts::CreatePost
  end
end
