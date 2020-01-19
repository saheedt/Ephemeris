module Queries
  module Users
    class GetUser < Queries::BaseQuery
      AUTH_HELPER = AuthHelper::Auth
      AUTH_MSG_HELPER = MessagesHelper::Auth
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      USERS_HELPER = UsersHelper::Users

      description "Fetch user record with all it's topics"

      # Data type to return to the client
      # @param Data type, null
      type Types::UserType, null: false

      # Incoming argument to query user resource with
      # @param args name, data_type, required
      argument :uuid, String, required: true

      # Handles user query request
      # @param uuid
      # @return UserType
      def resolve(uuid:)
        token = context[:current_user][:token]
        search_means = USERS_HELPER.default_search_means
        user = USERS_HELPER.fetch_with_relationship_by({"#{search_means}": uuid}, :posts)
        if token.present?
          auth = AUTH_HELPER.new(token)
          token_data = auth.verify_token
          return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
          USERS_HELPER.read(user, token_data[:verified_user][:uuid])
        else
          USERS_HELPER.read(user)
        end
      end
    end
  end
end
