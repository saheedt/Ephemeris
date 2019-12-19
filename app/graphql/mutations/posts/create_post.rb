module Mutations
  module Posts
    class CreatePost < Mutations::BaseMutation
      argument :title, String, required: false
      argument :content, String, required: false
      argument :topic_uuid, String, required: true

      field :post, Types::PostType, null: true

      def resolve(title: "Untitled", content: "", topic_uuid:)
        auth = AuthHelper::Auth.new(context[:current_user][:token])
        token_data = auth.verify_token
        if token_data[:verified?]
          search_means = TopicsHelper::Topics.default_topic_search_means
          topic = TopicsHelper::Topics.fetch_with_relationship_by({"#{search_means}": topic_uuid} , :user)
          topic_owner = topic.user
          return ExceptionHandlerHelper::GQLCustomError.new(MessagesHelper::Auth.user_unauthorized) unless auth.isAuthorized?(topic_owner[:uuid])
          title = "Untitled" if title.blank?
          PostHelper::Posts.create(title, content, topic[:id])
        else
          ExceptionHandlerHelper::GQLCustomError.new(MessagesHelper::Auth.token_verification_error)
        end
      end
    end
  end
end
