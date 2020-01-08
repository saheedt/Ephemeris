module UsersHelper
  class Users
    AUTH_MSG_HELPER = MessagesHelper::Auth
    RESOURCE_MSG_HELPER = MessagesHelper::Resource
    POST_HELPER = PostHelper::Posts

    def self.create(user_obj)
      user = User.new(email: user_obj[:email], password: user_obj[:password],
                      password_confirmation: user_obj[:password_confirmation],
                      screen_name: user_obj[:screen_name], name: user_obj[:name])
      if user.save
        to_encode = { uuid: user[:uuid] }
        build_user_response(build_user_object(user), AuthHelper::Jwt.encode(to_encode))
      else
        ExceptionHandlerHelper::GQLCustomError.new(user.errors.full_messages)
      end
    end

    def self.login(email, password)
      user = User.find_by(email: email)
      to_encode = { uuid: user[:uuid] } if user.present?
      return ExceptionHandlerHelper::GQLCustomError.new(MessagesHelper::Users.not_found(email)) if user.blank?
      return ExceptionHandlerHelper::GQLCustomError.new(MessagesHelper::Users.invalid_credentials) unless user.authenticate(password)
      return build_user_response(build_user_object(user), AuthHelper::Jwt.encode(to_encode)) if user.authenticate(password)
    end

    def self.fetch_by(type)
      User.select(:id).find_by(type)
    end

    def self.fetch_with_relationship_by(type, *relationship)
      User.includes(relationship).find_by(type)
    end

    def self.default_user_search_means(means = "uuid")
      means
    end

    def self.extract_post(user_obj, post_uuid)
      post = user_obj.posts.select{ |post| post if post[:uuid] === post_uuid }.first
      return build_extract_post_response(post) if post.present?
      verify_post_existence(post_uuid, post)
    end

    def self.verify_post_existence(post_uuid, post_obj)
      verification =  Post.find_by("#{default_user_search_means}": post_uuid)
      return build_extract_post_response(nil, AUTH_MSG_HELPER.user_unauthorized) if post_obj.blank? && verification.present?
      build_extract_post_response(nil, RESOURCE_MSG_HELPER.not_found(POST_HELPER.resource_name)) if post_obj.blank? && verification.blank?
    end

    def self.build_extract_post_response(post, error_message = nil)
      {
        post: post,
        error_message: error_message
      }
    end

    def self.build_user_response(user_record, token)
      {
        user: user_record,
        token: token
      }
    end

    def self.build_user_object(user_record)
      {
        uuid: user_record[:uuid],
        email: user_record[:email],
        screen_name: user_record[:screen_name],
        name: user_record[:name]
      }
    end

    def self.resource_name
      self.name.split("::").last.singularize
    end
  end
end
