module Types
  class PostType < Types::BaseObject
    field :uuid, String, null: false
    field :title, String, null: false
    field :content, String, null: false
  end
end
