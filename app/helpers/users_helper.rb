module UsersHelper
  class Users
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
      user_obj.posts.map{ |post| post if post[:uuid] === post_uuid }
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
  end
end
