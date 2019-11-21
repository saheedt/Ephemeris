require 'rails_helper'

module Mutations
  module Users
    RSpec.describe CreateUser, type: :request do
      describe '.reslove' do
        it 'creates a user' do
          user = { email: "a@b.com", screen_name: "tester_a", password: "testingtester",
                   password_confirmation: "testingtester", name: "Test A"}

          post '/graphql', params: { query: graphQuery(user) }

          json = JSON.parse(response.body)
          data = json['data']['createUser']

          expect(data).to include(
                            'user' => {
                              'id' => be_present,
                              'email' => 'a@b.com',
                              'screenName' => 'tester_a',
                            },
                            'token' => be_present,
                            'errors' => nil
                          )
        end
      end
      def graphQuery(user)
        <<~GQL
          mutation {
            createUser(input: {
              email: "#{user[:email]}"
              screenName: "#{user[:screen_name]}"
              password: "#{user[:password]}"
              passwordConfirmation: "#{user[:password_confirmation]}"
              name: "#{user[:name]}"
            }) {
              user {
                id
                email
                screenName
              }
              token
              errors
            }
          }
        GQL
      end
    end
  end
end