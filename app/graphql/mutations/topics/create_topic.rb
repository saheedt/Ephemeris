module Mutations
  module Topics
    class CreateTopic < Mutations::BaseMutation
      argument :title, String, required: false
      argument :is_public, Boolean, required: false

      field :topic, Types::TopicType, null: true

      def resolve(title: 'Untitled', is_public: false)
        auth = AuthHelper::Auth.new(context[:current_user][:token])
        token_data = auth.verify_token
        if token_data[:verified?]
          search_means = UsersHelper::Users.default_user_search_means
          current_user_id = UsersHelper::Users.fetch_by("#{search_means}": token_data[:verified_user][:uuid])[:id]
          TopicsHelper::Topics.create(title, is_public, current_user_id)
        else
          ExceptionHandlerHelper::GQLCustomError.new(MessagesHelper::Auth.token_verification_error)
        end
      end
    end
  end
end