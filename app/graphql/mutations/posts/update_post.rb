module Mutations
  module Posts
    class UpdatePost < Mutations::BaseMutation
      AUTH_HELPER = AuthHelper::Auth
      AUTH_MSG_HELPER = MessagesHelper::Auth
      EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
      POST_HELPER = PostHelper::Posts
      USERS_HELPER = UsersHelper::Users
      DEFAULT_POST_TITLE = "Untitled"
      DEFAULT_VISIBILITY_STATUS = false

      argument :post_uuid, String, required: true
      argument :content, String, required: false
      argument :title, String, required: false
      argument :is_public, Boolean, required: false

      field :post, Types::PostType, null: true

      def resolve(title: DEFAULT_POST_TITLE, content:, is_public: DEFAULT_VISIBILITY_STATUS, post_uuid:)
        auth = AUTH_HELPER.new(context[:current_user][:token])
        token_data = auth.verify_token
        return EXCEPTION_HANDLER.new(AUTH_MSG_HELPER.token_verification_error) unless token_data[:verified?]
        search_means = POST_HELPER.default_search_means
        current_user = USERS_HELPER.fetch_with_relationship_by({"#{search_means}": token_data[:verified_user][:uuid]},
                                                               :posts)
        extracted_post = USERS_HELPER.extract_post(current_user, post_uuid)
        post = extracted_post[:post]
        return EXCEPTION_HANDLER.new(extracted_post[:error_message]) if post.blank?
        topic = post.topic
        title = POST_HELPER.parse_title(title, DEFAULT_POST_TITLE)
        is_public = POST_HELPER.infer_visibility_status(topic, is_public)
        POST_HELPER.update(post, topic[:uuid], {title: title, content: content, is_public: is_public})
      end
    end
  end
end
