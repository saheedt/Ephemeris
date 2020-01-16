module Types
  class TopicType < Types::BaseObject
    field :uuid, String, null: false
    field :title, String, null: false
    field :posts, [Types::PostType], null: true
  end
end
