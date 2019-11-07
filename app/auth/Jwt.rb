class Jwt
  def self.encode(data)
    JWT.encode data, ENV['JWTSecret'], ENV['JWTEncryptionType']
  end
  def self.decode(token)
    verifyJWT = true
    JWT.decode token, ENV['JWTSecret'], verifyJWT, { :algorithm => ENV['JWTEncryptionType'] }
  end
end