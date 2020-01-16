module Mutations
  module Posts
    class CreatePost < Mutations::BaseMutation
      AUTH_HELPER = AuthHelper::Auth
      TOPIC_HELPER = TopicsHelper::Topics
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      AUTH_MSG_HELPER = MessagesHelper::Auth
      POST_HELPER = PostHelper::Posts
      DEFAULT_POST_TITLE = "Untitled"
      DEFAULT_CONTENT = ""
      DEFAULT_VISIBILITY_STATUS = false

      argument :topic_uuid, String, required: true
      argument :title, String, required: false
      argument :content, String, required: false
      argument :is_public, Boolean, required: false

      field :post, Types::PostType, null: true

      def resolve(title: DEFAULT_POST_TITLE, content: DEFAULT_CONTENT, is_public: DEFAULT_VISIBILITY_STATUS, topic_uuid:)
        auth = AUTH_HELPER.new(context[:current_user][:token])
        token_data = auth.verify_token
        return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
        search_means = TOPIC_HELPER.default_search_means
        topic = TOPIC_HELPER.fetch_with_relationship_by({"#{search_means}": topic_uuid} , :user)
        topic_owner = topic.user
        return EXCEPTION_HANDLER.new(MessagesHelper::Auth.user_unauthorized) unless auth.isAuthorized?(topic_owner[:uuid])
        title = POST_HELPER.parse_title(title, DEFAULT_POST_TITLE)
        is_public = POST_HELPER.infer_visibility_status(topic, is_public)
        POST_HELPER.create(title, content, is_public, topic)
      end
    end
  end
end
