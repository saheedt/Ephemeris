require 'rails_helper'
module Mutations
  module Topics
    RSpec.describe CreateTopic, type: :request  do
      describe '.resolve' do
        token = nil
        before(:all) do
          create(:user)
          post '/graphql', params: { query: login_mutation(dummy_login_credentials) }
          json = JSON.parse(response.body)
          token = json['data']['userLogin']['token']
        end

        after(:all) do
          User.destroy_all
        end

        it 'should not successfully create a topic without token' do
          post '/graphql', params: { query: topic_mutation("createTopic", dummy_topic_credentials) }

          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.token_verification_error )
        end

        it 'should not create a topic with an invalid token' do
          post '/graphql', params: { query: topic_mutation("createTopic", dummy_topic_credentials('second test', true)) },
               headers: { Authorization: fake_token }
          json = JSON.parse(response.body)
          errors = json["errors"]
          expect(errors).to include(
                              "message" => MessagesHelper::Auth.invalid_token
                            )
        end

        it 'should not create a topic with an expired token' do
          post '/graphql', params: { query: topic_mutation("createTopic", dummy_topic_credentials('second test', true)) },
               headers: { Authorization: fake_token(expired_token) }
          json = JSON.parse(response.body)
          errors = json["errors"]
          expect(errors).to include(
                              "message" => MessagesHelper::Auth.expired_token
                            )
        end

        it 'should successfully create a topic without one supplied credential' do
          post '/graphql', params: { query: topic_mutation("createTopic", dummy_topic_credentials('successful')) },
               headers: { Authorization: token }
          json = JSON.parse(response.body)
          topic = json['data']['createTopic']['topic']
          expect(topic).to include(
                             "uuid" => be_present,
                             "title" => "successful"
                           )
        end

        it 'should successfully create a topic with all supplied credentials' do
          post '/graphql', params: { query: topic_mutation("createTopic", dummy_topic_credentials('second test', true)) },
               headers: { Authorization: token }
          json = JSON.parse(response.body)
          topic = json['data']['createTopic']['topic']
          expect(topic).to include(
                             "uuid" => be_present,
                             "title" => "second test"
                           )
        end
      end
    end
  end
end
