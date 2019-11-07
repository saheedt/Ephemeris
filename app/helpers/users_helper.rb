module UsersHelper
  class Users
    def self.create(email, password, password_confirmation, screen_name, name)
      user = User.new(email: email, password: password, password_confirmation: password_confirmation,
                      screen_name: screen_name, name: name)
      if user.save
        {
          user: user,
          token: Jwt.encode(user),
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
  end
end
