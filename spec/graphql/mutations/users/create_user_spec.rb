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
                              'email' => user[:email],
                              'screenName' => user[:screen_name],
                              'name' => user[:name]
                            },
                            'token' => be_present,
                          )
        end

        it 'should not creates a user with incorrect credentials format' do
          user = { email: "a@b.com", screen_name: "tester_a", password: "testingtester",
                   password_confirmation: "testing", name: "Test A"}

          post '/graphql', params: { query: create_user_mutation(user) }

          json = JSON.parse(response.body)
          data = json["data"]
          errors = json["errors"][0]

          expect(data).to include(
                            { 'createUser' => nil }
                          )
          expect(errors).to include(
                             {"message" => [ "Password confirmation doesn't match Password" ]}
                           )
        end

        it 'should not re-create an already existing user' do
          user = { email: "a@b.com", screen_name: "tester_a", password: "testingtester",
                   password_confirmation: "testingtester", name: "Test A"}

          post '/graphql', params: { query: create_user_mutation(user) }
          post '/graphql', params: { query: create_user_mutation(user) }

          json = JSON.parse(response.body)
          errors = json["errors"][0]

          expect(errors).to include(
                              {"message" => [
                                "Email has already been taken",
                                "Screen name has already been taken"
                              ]}
                            )
        end
      end
    end
  end
end
