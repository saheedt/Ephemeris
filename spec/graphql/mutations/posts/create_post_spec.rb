require 'rails_helper'
module Mutations
  module Posts
    RSpec.describe CreatePost, type: :request  do
      describe '.resolve' do
        token = nil
        topic_uuid = nil
        before(:all) do
          create(:user)
          post '/graphql', params: { query: login_mutation(dummy_login_credentials) }
          json = JSON.parse(response.body)
          token = json['data']['userLogin']['token']
        end

        after(:all) do
          User.destroy_all
        end

        before(:each) do
          post '/graphql', params: { query: topic_mutation("createTopic", dummy_topic_credentials('successful')) },
               headers: { Authorization: token }
          json = JSON.parse(response.body)
          topic_uuid = json['data']['createTopic']['topic']['uuid']
        end

        after(:each) do
          Topic.destroy_all
        end

        it 'should not successfully create a post without token' do
          post '/graphql', params: { query: create_post_mutation(dummy_post_credentials(topic_uuid)) }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.token_verification_error )
        end

        it 'should not successfully create post with expired token' do
          post '/graphql', params: { query: create_post_mutation(dummy_post_credentials(topic_uuid)) },
               headers: { Authorization: fake_token(expired_token) }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.expired_token )
        end

        it 'should not successfully create post with invalid token' do
          post '/graphql', params: { query: create_post_mutation(dummy_post_credentials(topic_uuid)) },
               headers: { Authorization: fake_token }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.invalid_token )
        end

        it 'should successfully create a post for a topic' do
          post '/graphql', params: { query: create_post_mutation(dummy_post_credentials(topic_uuid)) },
               headers: { Authorization: token }
          json = JSON.parse(response.body)
          post = json['data']['createPost']['post']
          expect(post).to include(
                            "uuid" => be_present,
                            "title" => dummy_post_credentials[:title],
                            "content" => dummy_post_credentials[:content]
                          )
        end

        it 'should successfully create post with the right title in every situation' do
          post '/graphql', params: { query: create_post_mutation(dummy_post_credentials(topic_uuid, "")) },
               headers: { Authorization: token }
          json = JSON.parse(response.body)
          post = json['data']['createPost']['post']
          expect(post).to include(
                            "uuid" => be_present,
                            "title" => "Untitled",
                            "content" => dummy_post_credentials[:content]
                          )
        end

        it 'should successfully create post with the right content in every situation' do
          post '/graphql', params: { query: create_post_mutation(dummy_post_credentials(topic_uuid, "", nil)) },
               headers: { Authorization: token }
          json = JSON.parse(response.body)
          post = json['data']['createPost']['post']
          expect(post).to include(
                            "uuid" => be_present,
                            "title" => "Untitled",
                            "content" => ""
                          )
        end

        it 'should return User unauthorized error if a user tries to add post to topic other than theirs' do
          user_obj = { name: 'alt_user', screen_name: 'alt_user_p', email: 'alt_user@test.com',
                       password: '1234567890', password_confirmation: '1234567890' }
          create(:user, user_obj)
          post '/graphql', params: { query: login_mutation(dummy_login_credentials(user_obj[:email], user_obj[:password])) }
          json = JSON.parse(response.body)
          local_token = json['data']['userLogin']['token']

          post '/graphql', params: { query: create_post_mutation(dummy_post_credentials(topic_uuid, "", nil)) },
               headers: { Authorization: local_token }
          json = JSON.parse(response.body)
          error = json['errors'][0]

          expect(error).to include( "message" => MessagesHelper::Auth.user_unauthorized )
        end
      end
    end
  end
end
