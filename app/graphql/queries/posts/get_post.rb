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
      # field :post, Types::PostType, null: true

      argument :post_uuid, String, required: true

      def resolve(post_uuid:)
        token = context[:current_user][:token]
        if token.present?
          auth = AUTH_HELPER.new(context[:current_user][:token])
          token_data = auth.verify_token
          return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
          search_means = USERS_HELPER.default_search_means
          current_user = USERS_HELPER.fetch_with_relationship_by({"#{search_means}": token_data[:verified_user][:uuid]},
                                                                 :posts)
          POST_HELPER.get(post_uuid, current_user)
        else
          POST_HELPER.get(post_uuid)
        end
      end
    end
  end
end
