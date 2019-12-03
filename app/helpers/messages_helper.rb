module MessagesHelper
  class Users
    def self.not_found(record)
      "User '#{record}' not found"
    end
    def self.invalid_credentials
      "Invalid credentials supplied"
    end
  end
end
