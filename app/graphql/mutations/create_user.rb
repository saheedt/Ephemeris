class Mutations::CreateUser < Mutations::BaseMutation
  argument :email, String, required: true
  argument :password, String, required: true
  argument :password_confirmation, String, required: true
  argument :screen_name, String, required: true
  argument :name, String, required: false

  field :user, Types::UserType, null: false
  field :token, String, null: false
  field :errors, [String], null: false

  def resolve(email:, password:, password_confirmation:, screen_name:, name:)
    # fix silent DB rollback creating duplicate user
    UsersHelper::Users.create(email, password, password_confirmation, screen_name, name)
  end
end