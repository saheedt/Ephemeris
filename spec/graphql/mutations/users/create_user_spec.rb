require 'rails_helper'
module Mutations
  module Users
    RSpec.describe CreateUser, type: :request do
      describe '.reslove' do
        after(:all) do
          User.destroy_all
        end

        it 'should creates a user' do
          user = { email: "a@b.com", screen_name: "tester_a", password: "testingtester",
                   password_confirmation: "testingtester", name: "Test A"}

          post '/graphql', params: { query: create_user_mutation(user) }

          json = JSON.parse(response.body)
          data = json['data']['createUser']

          expect(data).to include(
                            'user' => {
                              'uuid' => be_present,
                              'email' => 'a@b.com',
                              'screenName' => 'tester_a',
                            },
                            'token' => be_present,
                            'errors' => nil
                          )
        end

        it 'should not creates a user with incomplete credentials' do
          user = { email: "a@b.com", screen_name: "tester_a", password: "testingtester",
                   password_confirmation: "testing", name: "Test A"}

          post '/graphql', params: { query: create_user_mutation(user) }

          json = JSON.parse(response.body)
          data = json['data']['createUser']

          expect(data).to include(
                            'user' => nil,
                            'token' => nil,
                            'errors' => [ "Password confirmation doesn't match Password" ]
                          )
        end

      end
    end
  end
end
