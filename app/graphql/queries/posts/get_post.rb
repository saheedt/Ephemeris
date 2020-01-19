module Queries
  module Posts
    class GetPost < Queries::BaseQuery
      AUTH_HELPER = AuthHelper::Auth
      AUTH_MSG_HELPER = MessagesHelper::Auth
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      POST_HELPER = PostHelper::Posts
      USERS_HELPER = UsersHelper::Users

      description "Fetch a post"

      type Types::PostType, null: true

      argument :uuid, String, required: true

      def resolve(uuid:)
        token = context[:current_user][:token]
        if token.present?
          auth = AUTH_HELPER.new(token)
          token_data = auth.verify_token
          return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
          POST_HELPER.read(uuid, token_data[:verified_user][:uuid])
        else
          POST_HELPER.read(uuid)
        end
      end
    end
  end
end
