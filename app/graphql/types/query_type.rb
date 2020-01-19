module Types
  class QueryType < Types::BaseObject
    field :post, resolver: Queries::Posts::GetPost
    field :topic, resolver: Queries::Topics::GetTopic
    field :user, resolver: Queries::Users::GetUser
  end
end
