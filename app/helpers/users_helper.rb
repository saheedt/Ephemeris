module UsersHelper
  class Users
    def self.create(email, password, password_confirmation, screen_name, name)
      user = User.new(email: email, password: password, password_confirmation: password_confirmation,
                      screen_name: screen_name, name: name)
      if user.save
        {
          user: user,
          token: AuthHelper::Jwt.encode(user),
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
      return { user: nil, token: nil, error: MessagesHelper::Users.not_found(email) } if user.blank?
      return { user: nil, token: nil, error: MessagesHelper::Users.invalid_credentials } if !user&.authenticate(password)
      return { user: user, token: AuthHelper::Jwt.encode(user), error: nil } if user&.authenticate(password)
    end
  end
end
