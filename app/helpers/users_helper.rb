module UsersHelper
  class Users
    def self.create(email, password, password_confirmation, screen_name, name)
      user = User.new(email: email, password: password, password_confirmation: password_confirmation,
                      screen_name: screen_name, name: name)
      if user.save
        to_encode = { uuid: user[:uuid] }
        {
          user: user,
          token: AuthHelper::Jwt.encode(to_encode),
          errors: nil
        }
      else
        {
          user: nil,
          token: nil,
          errors: user.errors.full_messages
        }
      end
    end

    def self.login(email, password)
      user = User.find_by(email: email)
      to_encode = { uuid: user[:uuid] } if user.present?
      return { user: nil, token: nil, error: MessagesHelper::Users.not_found(email) } if user.blank?
      return { user: nil, token: nil, error: MessagesHelper::Users.invalid_credentials } unless user.authenticate(password)
      return { user: user, token: AuthHelper::Jwt.encode(to_encode), error: nil } if user.authenticate(password)
    end

    def self.fetch_by(type)
      User.select(:id).find_by(type)
    end

    def self.default_user_search_means
      "uuid"
    end

  end
end
