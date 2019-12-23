module Mutations
  module Topics
    class UpdateTopic < Mutations::BaseMutation
      AUTH_HELPER = AuthHelper::Auth
      TOPIC_HELPER = TopicsHelper::Topics
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      AUTH_MSG_HELPER = MessagesHelper::Auth

      argument :title, String, required: false
      argument :is_public, Boolean, required: false
      argument :topic_uuid, String, required: true

      field :topic, Types::TopicType, null: true

      def resolve(title: 'Untitled', is_public:, topic_uuid:)
        auth = AUTH_HELPER.new(context[:current_user][:token])
        token_data = auth.verify_token
        return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
        search_means = TOPIC_HELPER.default_topic_search_means
        topic = TOPIC_HELPER.fetch_with_relationship_by({"#{search_means}": topic_uuid} , :user)
        return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.user_unauthorized) unless auth.isAuthorized?(topic.user[:uuid])
        title = 'Untitled' if title.blank?
        TOPIC_HELPER.update(topic, { title: title, is_public: is_public })
      end
    end
  end
end
