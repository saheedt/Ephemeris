module Mutations
  module Posts
    class UpdatePost < Mutations::BaseMutation
      AUTH_HELPER = AuthHelper::Auth
      AUTH_MSG_HELPER = MessagesHelper::Auth
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      POST_HELPER = PostHelper::Posts
      USERS_HELPER = UsersHelper::Users

      argument :content, String, required: false
      argument :title, String, required: false
      argument :post_uuid, String, required: true

      field :post, Types::PostType, null: true

      def resolve(title: 'Untitled', content:, post_uuid:)
        auth = AUTH_HELPER.new(context[:current_user][:token])
        token_data = auth.verify_token
        return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
        search_means = POST_HELPER.default_search_means
        current_user = USERS_HELPER.fetch_with_relationship_by({"#{search_means}": token_data[:verified_user][:uuid]},
                                                               :posts)
        post = USERS_HELPER.extract_post(current_user, post_uuid)
        return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.user_unauthorized) if post.blank?
        post = post.first
        title = "Untitled" if title.blank?
        POST_HELPER.update(post, {title: title, content: content})
      end
    end
  end
end
