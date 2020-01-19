require 'rails_helper'

module Queries
  module Posts
    RSpec.describe GetPost, type: :request do
      describe '.resolve' do

        before(:all) do
          @user = create(:user)
          @topic = create(:topic, { user: @user })
          @post = create(:post, { topic: @topic })

          post '/graphql', params: { query: login_mutation(dummy_login_credentials) }
          json = JSON.parse(response.body)
          @token = json['data']['userLogin']['token']
        end

        after(:all) do
          User.destroy_all
        end

        it 'should return not found error for non-author if post / topic is not public' do
          create(:user, secondary_user)
          post '/graphql', params: { query: login_mutation(dummy_login_credentials(secondary_user[:email], secondary_user[:password])) }
          json = JSON.parse(response.body)
          local_token = json['data']['userLogin']['token']

          post '/graphql', params: { query: get_post_query(post_uuid: @user[:uuid]) }, headers: { Authorization: local_token }
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
          post '/graphql', params: { query: get_post_query(post_uuid: @post[:uuid]) },
               headers: { Authorization: fake_token(expired_token) }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.expired_token )
        end

        it 'should not successfully fetch post with invalid token' do
          post '/graphql', params: { query: get_post_query(post_uuid: @post[:uuid]) },
               headers: { Authorization: fake_token }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.invalid_token )
        end

        it 'should return post without authorization if topic and post are public' do
          local_topic = create(:topic, { user: @user, is_public: true })
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
          post '/graphql', params: { query: get_post_query(post_uuid: @post[:uuid]) }, headers: { Authorization: @token }
          json = JSON.parse(response.body)
          post = json['data']['post']
          expect(post).to include(
                            "uuid" => @post[:uuid],
                            "title" => @post[:title],
                            "content" => @post[:content],
                            "topicUuid" => @topic[:uuid]
                          )
        end
      end
    end
  end
end
