module Mutations
  module Users
    class UserLogin < Mutations::BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :user, Types::UserType, null: true
      field :token, String, null: true
      field :error, String, null: true

      def resolve(email:, password:)
        UsersHelper::Users.login(email, password)
      end
    end
  end
end