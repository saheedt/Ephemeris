module Mutations
  module Users
    class CreateUser < Mutations::BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true
      argument :screen_name, String, required: true
      argument :name, String, required: false

      field :user, Types::UserType, null: true
      field :token, String, null: true

      def resolve(email:, password:, password_confirmation:, screen_name:, name:)
        user_obj = { 'email': email, 'password': password,
                     'password_confirmation': password_confirmation,
                     'screen_name': screen_name, 'name': name
        }
        UsersHelper::Users.create(user_obj)
      end
    end
  end
end
