module Mutations
  module Topics
    class DeleteTopic < Mutations::BaseMutation
      AUTH_HELPER = AuthHelper::Auth
      AUTH_MSG_HELPER = MessagesHelper::Auth
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      TOPIC_HELPER = TopicsHelper::Topics
      USER_HELPER = UsersHelper::Users
      RESOURCE_HELPER = MessagesHelper::Resource

      argument :topic_uuid, String, required: true

      field :topic, Types::TopicType, null: true

      def resolve(topic_uuid:)
        auth = AUTH_HELPER.new(context[:current_user][:token])
        token_data = auth.verify_token
        return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
        search_means = TOPIC_HELPER.default_search_means
        topic = TOPIC_HELPER.fetch_with_relationship_by({"#{search_means}": topic_uuid}, :user)
        return EXCEPTION_HANDLER.new(RESOURCE_HELPER.not_found(TOPIC_HELPER.resource_name)) if topic.blank?
        return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.user_unauthorized) unless auth.isAuthorized?(topic.user[:uuid])
        TOPIC_HELPER.destroy(topic)
      end
    end
  end
end
