module Types
  class TopicType < Types::BaseObject
    field :uuid, String, null: false
    field :title, String, null: false
  end
end
