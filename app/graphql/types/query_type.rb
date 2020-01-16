module Types
  class QueryType < Types::BaseObject
    field :post, resolver: Queries::Posts::GetPost
    field :topic, resolver: Queries::Topics::GetTopic
  end
end
