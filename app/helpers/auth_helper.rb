module AuthHelper
  class Jwt
    JWT_SECRET = ENV['JWTSecret']
    ENCRYPTION_TYPE = ENV['JWTEncryptionType']
    VERIFY_JWT = true

    def self.encode(data, expiry = 2.weeks.from_now)
      data[:exp] = expiry.to_i
      JWT.encode data, JWT_SECRET, ENCRYPTION_TYPE
    end

    def self.decode(token)
      body = JWT.decode(token, JWT_SECRET, VERIFY_JWT, { :algorithm => ENCRYPTION_TYPE })[0]
      HashWithIndifferentAccess.new(body)
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      raise ExceptionHandlerHelper::GQLCustomError.new( message: MessagesHelper::Auth.expired_token )
    rescue JWT::DecodeError, JWT::VerificationError => e
      raise ExceptionHandlerHelper::GQLCustomError.new( message: MessagesHelper::Auth.invalid_token )
    end
  end

  class Auth
    def initialize(token)
      @token = token
    end

    def has_token?
      return false if @token.blank?
      true if @token.present?
    end

    def verify_token
      return { verified?: false, verified_user: nil } unless has_token?
      @decoded = Jwt.decode(@token)
      return { verified?: true, verified_user: @decoded } if @decoded[:uuid].present? and @decoded[:exp].present?
      { verified?: false, verified_user: nil }
    end

    def isAuthorized?(resource_owner_uuid)
      resource_owner_uuid === @decoded[:uuid]
    end
  end
end
