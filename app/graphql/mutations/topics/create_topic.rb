module Mutations
  module Topics
    class CreateTopic < Mutations::BaseMutation
      TOPIC_HELPER = TopicsHelper::Topics
      AUTH_HELPER = AuthHelper::Auth
      USER_HELPER = UsersHelper::Users
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      DEFAULT_TOPIC_TITLE = "Untitled"

      argument :title, String, required: false
      argument :is_public, Boolean, required: false

      field :topic, Types::TopicType, null: true

      def resolve(title: DEFAULT_TOPIC_TITLE, is_public: false)
        auth = AUTH_HELPER.new(context[:current_user][:token])
        token_data = auth.verify_token
        if token_data[:verified?]
          search_means = USER_HELPER.default_user_search_means
          current_user_id = USER_HELPER.fetch_by("#{search_means}": token_data[:verified_user][:uuid])[:id]
          title = TOPIC_HELPER.parse_title(title, DEFAULT_TOPIC_TITLE)
          TOPIC_HELPER.create(title, is_public, current_user_id)
        else
          EXCEPTION_HANDLER.new(MessagesHelper::Auth.token_verification_error)
        end
      end
    end
  end
end
