class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email, :screen_name, :password_digest
  validates :email, uniqueness: { scope: :screen_name }
end
