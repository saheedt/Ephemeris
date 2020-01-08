require 'rails_helper'
module Mutations
  module Posts
    RSpec.describe DeletePost, type: :request do
      token = nil
      topic_uuid = nil
      post_uuids = []
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
        post_uuids = []
        post '/graphql', params: { query: topic_mutation("createTopic", dummy_topic_credentials('successful topic')) },
             headers: { Authorization: token }
        json = JSON.parse(response.body)
        topic_uuid = json['data']['createTopic']['topic']['uuid']

        post '/graphql', params: { query: create_post_mutation(dummy_post_credentials(topic_uuid, "")) },
             headers: { Authorization: token }
        json = JSON.parse(response.body)
        post_uuids << json['data']['createPost']['post']['uuid']

        post '/graphql', params: { query: create_post_mutation(dummy_post_credentials(topic_uuid)) },
             headers: { Authorization: token }
        json = JSON.parse(response.body)
        post_uuids << json['data']['createPost']['post']['uuid']
      end

      after(:each) do
        Topic.destroy_all
      end

      it 'should not successfully delete a post without token' do
        post '/graphql', params: { query: delete_post_mutation(post_uuid: post_uuids.first) }
        json = JSON.parse(response.body)
        error = json['errors'][0]
        expect(error).to include( "message" => MessagesHelper::Auth.token_verification_error )
      end

      it 'should not successfully delete post with expired token' do
        post '/graphql', params: { query: delete_post_mutation(post_uuid: post_uuids.first) },
             headers: { Authorization: fake_token(expired_token) }
        json = JSON.parse(response.body)
        error = json['errors'][0]
        expect(error).to include( "message" => MessagesHelper::Auth.expired_token )
      end

      it 'should not successfully delete post with invalid token' do
        post '/graphql', params: { query: delete_post_mutation(post_uuid: post_uuids.first) },
             headers: { Authorization: fake_token }
        json = JSON.parse(response.body)
        error = json['errors'][0]
        expect(error).to include( "message" => MessagesHelper::Auth.invalid_token )
      end

      it 'should return not found error if non-existing uuid is supplied' do
        post '/graphql', params: { query: delete_post_mutation(post_uuid: "non-existent") },
             headers: { Authorization: token }
        json = JSON.parse(response.body)
        error = json['errors'][0]
        expect(error).to include( "message" => MessagesHelper::Resource.not_found(PostHelper::Posts.resource_name) )
      end

      it 'should not delete posts belonging to other users' do
        user_obj = { name: 'alt_user', screen_name: 'alt_user_p', email: 'alt_user@test.com',
                     password: '1234567890', password_confirmation: '1234567890' }
        create(:user, user_obj)
        post '/graphql', params: { query: login_mutation(dummy_login_credentials(user_obj[:email], user_obj[:password])) }
        json = JSON.parse(response.body)
        local_token = json['data']['userLogin']['token']

        post '/graphql', params: { query: delete_post_mutation(post_uuid: post_uuids.first) },
             headers: { Authorization: local_token }
        json = JSON.parse(response.body)
        error = json['errors'][0]

        expect(error).to include( "message" => MessagesHelper::Auth.user_unauthorized )
      end

      it 'should successfully delete first post' do
        post '/graphql', params: { query: delete_post_mutation(post_uuid: post_uuids.first) },
             headers: { Authorization: token }
        json = JSON.parse(response.body)
        post = json['data']['deletePost']['post']
        expect(post).to include(
                          "uuid" => be_present,
                          "title" => "Untitled",
                          "content" => dummy_post_credentials[:content]
                        )
      end

      it 'should successfully delete second post' do
        post '/graphql', params: { query: delete_post_mutation(post_uuid: post_uuids.second) },
             headers: { Authorization: token }
        json = JSON.parse(response.body)
        post = json['data']['deletePost']['post']
        expect(post).to include(
                          "uuid" => be_present,
                          "title" => dummy_post_credentials[:title],
                          "content" => dummy_post_credentials[:content]
                        )
      end

    end
  end
end
