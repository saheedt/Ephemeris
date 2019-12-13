module MessagesHelper
  class Users
    def self.not_found(record)
      "User '#{record}' not found"
    end
    def self.invalid_credentials
      "Invalid credentials supplied"
    end
  end

  class Auth
    def self.invalid_token
      "Access Denied!. Invalid token supplied"
    end
    def self.expired_token
      "Access Denied!. Expired token"
    end
    def self.token_verification_error
      "Access Denied. Couldn't verify token validity"
    end
  end
end
