require 'rails_helper'

module Queries
  module Users
    RSpec.describe GetUser, type: :request do
      describe '.resolve' do

        before(:all) do
          @user_1 = create(:user)
          @user_2 = create(:user, secondary_user)

          @topic_1 = create(:topic, { user: @user_1, is_public: true })
          @topic_2 = create(:topic, {user: @user_2, is_public: false})

          @post_1 = create(:post, { topic: @topic_1, is_public: true })
          @post_2 = create(:post, { topic: @topic_1, is_public: false })
          @post_3 = create(:post, { topic: @topic_2, is_public: true })
          @post_4 = create(:post, { topic: @topic_2, is_public: false })


          post '/graphql', params: { query: login_mutation(dummy_login_credentials) }
          json = JSON.parse(response.body)
          @token = json['data']['userLogin']['token']
        end

        after(:all) do
          User.destroy_all
        end

        it 'should return not found error if user does not exist' do
          post '/graphql', params: { query: get_user_query(user_uuid: "fake_id") }
          json = JSON.parse(response.body)
          error = json["errors"][0]

          expect(error).to include(
                             "message" => MessagesHelper::Resource.not_found(UsersHelper::Users.resource_name)
                           )
        end

        it 'should not successfully fetch user with expired token' do
          post '/graphql', params: { query: get_user_query(user_uuid: @user_1[:uuid]) },
               headers: { Authorization: fake_token(expired_token) }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.expired_token )
        end

        it 'should not successfully fetch post with invalid token' do
          post '/graphql', params: { query: get_user_query(user_uuid: @user_1[:uuid]) },
               headers: { Authorization: fake_token }
          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.invalid_token )
        end

        it 'should return user with their public topic and posts for an unauthorized user' do
          local_topic = create(:topic, { user: @user_1, is_public: false })
          create(:post, { topic: local_topic, is_public: true })
          post '/graphql', params: { query: get_user_query(user_uuid: @user_1[:uuid]) }
          json = JSON.parse(response.body)
          user = json["data"]["user"]
          expect(user["topics"].length).to eq(1)
          expect(user["topics"][0]).to include(
                                         "uuid" => @topic_1[:uuid],
                                         "title" => @topic_1[:title]
                                       )
          expect(user["topics"][0]["posts"][0]).to include(
                                                  "uuid" => @post_1[:uuid],
                                                  "topicUuid" => @topic_1[:uuid]
                                                )
        end

        it 'should return user with all public/private topic and posts for author' do
          local_topic = create(:topic, { user: @user_1, is_public: false })
          local_post = create(:post, { topic: local_topic, is_public: true })
          post '/graphql', params: { query: get_user_query(user_uuid: @user_1[:uuid]) },
               headers: { Authorization: @token }
          json = JSON.parse(response.body)
          user = json["data"]["user"]
          expect(user["topics"].length).to eq(2)
          expect(user["topics"][0]).to include(
                                         "uuid" => @topic_1[:uuid],
                                         "title" => @topic_1[:title]
                                       )
          expect(user["topics"][1]).to include(
                                         "uuid" => local_topic[:uuid],
                                         "title" => local_topic[:title]
                                       )
          expect(user["topics"][0]["posts"][0]).to include(
                                                     "uuid" => @post_1[:uuid],
                                                     "topicUuid" => @topic_1[:uuid]
                                                   )
          expect(user["topics"][1]["posts"][0]).to include(
                                                     "uuid" => local_post[:uuid],
                                                     "topicUuid" => local_topic[:uuid]
                                                   )
        end

        it 'should return user with public topic and posts for non-author' do
          local_topic = create(:topic, { user: @user_2, is_public: true })
          local_post = create(:post, { topic: local_topic, is_public: true })
          post '/graphql', params: { query: get_user_query(user_uuid: @user_2[:uuid]) },
               headers: { Authorization: @token }
          json = JSON.parse(response.body)
          user = json["data"]["user"]

          expect(user["topics"].length).to eq(1)
          expect(user["topics"][0]["posts"].length).to eq(1)
          expect(user["topics"][0]).to include(
                                         "uuid" => local_topic[:uuid],
                                         "title" => local_topic[:title]
                                       )
          expect(user["topics"][0]["posts"][0]).to include(
                                                     "uuid" => local_post[:uuid],
                                                     "topicUuid" => local_topic[:uuid]
                                                   )
        end

      end
    end
  end
end
