module Types
  class QueryType < Types::BaseObject
    field :post, resolver: Queries::Posts::GetPost
  end
end
