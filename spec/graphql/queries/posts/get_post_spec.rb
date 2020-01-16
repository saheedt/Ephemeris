require 'rails_helper'

module Queries
  module Posts
    RSpec.describe GetPost, type: :request do
      describe '.resolve' do
        glob_user = nil
        glob_post = nil
        glob_topic = nil
        token = nil

        before(:all) do
          glob_user = create(:user)
          glob_topic = create(:topic, { user: glob_user })
          glob_post = create(:post, { topic: glob_topic })

          post '/graphql', params: { query: login_mutation(dummy_login_credentials) }
          json = JSON.parse(response.body)
          token = json['data']['userLogin']['token']
        end

        after(:all) do
          User.destroy_all
        end

        it 'should return not found error for non-author if post / topic is not public' do
          user_obj = { name: 'alt_user', screen_name: 'alt_user_p', email: 'alt_user@test.com',
                       password: '1234567890', password_confirmation: '1234567890' }
          create(:user, user_obj)
          post '/graphql', params: { query: login_mutation(dummy_login_credentials(user_obj[:email], user_obj[:password])) }
          json = JSON.parse(response.body)
          local_token = json['data']['userLogin']['token']

          post '/graphql', params: { query: get_post_query(post_uuid: glob_post[:uuid]) }, headers: { Authorization: local_token }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Resource.not_found(PostHelper::Posts.resource_name) )
        end

        it 'should return not found error if post does not exist' do
          post '/graphql', params: { query: get_post_query(post_uuid: 'lol') }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Resource.not_found(PostHelper::Posts.resource_name) )
        end

        it 'should not successfully fetch post with expired token' do
          post '/graphql', params: { query: get_post_query(post_uuid: glob_post[:uuid]) },
               headers: { Authorization: fake_token(expired_token) }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.expired_token )
        end

        it 'should not successfully fetch post with invalid token' do
          post '/graphql', params: { query: get_post_query(post_uuid: glob_post[:uuid]) },
               headers: { Authorization: fake_token }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.invalid_token )
        end

        it 'should return post without authorization if topic and post are public' do
          local_topic = create(:topic, { user: glob_user, is_public: true })
          local_post = create(:post, { topic: local_topic, is_public: true })

          post '/graphql', params: { query: get_post_query(post_uuid: local_post[:uuid]) }
          json = JSON.parse(response.body)
          post = json['data']['post']
          expect(post).to include(
                            "uuid" => local_post[:uuid],
                            "title" => local_post[:title],
                            "content" => local_post[:content],
                            "topicUuid" => local_topic[:uuid]
                          )
        end

        it 'should return private post for author' do
          post '/graphql', params: { query: get_post_query(post_uuid: glob_post[:uuid]) }, headers: { Authorization: token }
          json = JSON.parse(response.body)
          post = json['data']['post']
          expect(post).to include(
                            "uuid" => glob_post[:uuid],
                            "title" => glob_post[:title],
                            "content" => glob_post[:content],
                            "topicUuid" => glob_topic[:uuid]
                          )
        end
      end
    end
  end
end
