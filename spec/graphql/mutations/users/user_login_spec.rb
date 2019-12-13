require 'rails_helper'
module Mutations
  module Users
    RSpec.describe UserLogin, type: :request do
      describe '.resolve' do
        before(:all) do
          create(:user)
        end

        after(:all) do
          User.destroy_all
        end

        it ' should successfully log user in' do
          user = { email: 'test@test.com', password: '1234567890' }

          post '/graphql', params: { query: login_mutation(user) }

          json = JSON.parse(response.body)
          data = json['data']['userLogin']

          expect(data).to include(
                            'user' => {
                              'uuid' => be_present,
                              'email' => 'test@test.com',
                              'screenName' => 'tester_p'
                            },
                            'token' => be_present,
                            'error' => nil
                          )
        end

        it 'should return invalid credential error' do
          user = { email: 'test@test.com', password: '123456789' }

          post '/graphql', params: { query: login_mutation(user) }

          json = JSON.parse(response.body)
          data = json['data']['userLogin']

          expect(data).to include(
                            'user' => nil,
                            'token' => nil,
                            'error' => MessagesHelper::Users.invalid_credentials
                          )
        end

        it 'should return user not found error' do
          user = { email: 'test@fail.com', password: '123456789' }

          post '/graphql', params: { query: login_mutation(user) }

          json = JSON.parse(response.body)
          data = json['data']['userLogin']

          expect(data).to include(
                            'user' => nil,
                            'token' => nil,
                            'error' => MessagesHelper::Users.not_found(user[:email])
                          )
        end

      end
    end
  end
end
