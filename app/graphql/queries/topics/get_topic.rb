module Queries
  module Topics
    class GetTopic < Queries::BaseQuery
      AUTH_HELPER = AuthHelper::Auth
      AUTH_MSG_HELPER = MessagesHelper::Auth
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      TOPIC_HELPER = TopicsHelper::Topics
      USERS_HELPER = UsersHelper::Users

      description "Fetch a topic"

      type Types::TopicType, null: false

      argument :uuid, String, required: true

      def resolve(uuid:)
        token = context[:current_user][:token]
        topic_search_means = TOPIC_HELPER.default_search_means
        topic = TOPIC_HELPER.fetch_with_relationship_by({"#{topic_search_means}": uuid }, :posts)
        if token.present?
          auth = AUTH_HELPER.new(token)
          token_data = auth.verify_token
          return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
          TOPIC_HELPER.read(topic, token_data[:verified_user][:uuid])
        else
          TOPIC_HELPER.read(topic)
        end
      end
    end
  end
end
