module Mutations
  module Posts
    class CreatePost < Mutations::BaseMutation
      AUTH_HELPER = AuthHelper::Auth
      TOPIC_HELPER = TopicsHelper::Topics
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      AUTH_MSG_HELPER = MessagesHelper::Auth

      argument :title, String, required: false
      argument :content, String, required: false
      argument :topic_uuid, String, required: true

      field :post, Types::PostType, null: true

      def resolve(title: "Untitled", content: "", topic_uuid:)
        auth = AuthHelper::Auth.new(context[:current_user][:token])
        token_data = auth.verify_token
        return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
        search_means = TOPIC_HELPER.default_topic_search_means
        topic = TOPIC_HELPER.fetch_with_relationship_by({"#{search_means}": topic_uuid} , :user)
        topic_owner = topic.user
        return EXCEPTION_HANDLER.new(MessagesHelper::Auth.user_unauthorized) unless auth.isAuthorized?(topic_owner[:uuid])
        title = "Untitled" if title.blank?
        PostHelper::Posts.create(title, content, topic[:id])
      end
    end
  end
end
