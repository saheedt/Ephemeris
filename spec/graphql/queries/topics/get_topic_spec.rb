require 'rails_helper'

module Queries
  module Topics
    RSpec.describe GetTopic, type: :request do
      before(:each) do
        @user = create(:user)
        @topic = create(:topic, { user: @user })
        post '/graphql', params: { query: login_mutation(dummy_login_credentials) }
        json = JSON.parse(response.body)
        @token = json['data']['userLogin']['token']
      end

      after(:all) do
        User.destroy_all
      end

      it 'should return not found for non-author if topic is private' do
        create(:user, secondary_user)
        post '/graphql', params: { query: login_mutation(dummy_login_credentials(secondary_user[:email], secondary_user[:password])) }
        json = JSON.parse(response.body)
        local_token = json['data']['userLogin']['token']

        post '/graphql', params: { query: get_topic_query(topic_uuid: @topic[:uuid]) }, headers: { Authorization: local_token }
        json = JSON.parse(response.body)
        error = json['errors'][0]
        expect(error).to include( "message" => MessagesHelper::Resource.not_found(TopicsHelper::Topics.resource_name) )
      end

      it 'should return not found error if topic does not exist' do
        post '/graphql', params: { query: get_topic_query(topic_uuid: 'none') }
        json = JSON.parse(response.body)
        error = json['errors'][0]
        expect(error).to include( "message" => MessagesHelper::Resource.not_found(TopicsHelper::Topics.resource_name) )
      end

      it 'should not successfully fetch topic with expired token' do
        post '/graphql', params: { query: get_topic_query(topic_uuid: @topic[:uuid]) },
             headers: { Authorization: fake_token(expired_token) }
        json = JSON.parse(response.body)
        error = json['errors'][0]
        expect(error).to include( "message" => MessagesHelper::Auth.expired_token )
      end

      it 'should not successfully fetch topic with invalid token' do
        post '/graphql', params: { query: get_topic_query(topic_uuid: @topic[:uuid]) },
             headers: { Authorization: fake_token }
        json = JSON.parse(response.body)
        error = json['errors'][0]
        expect(error).to include( "message" => MessagesHelper::Auth.invalid_token )
      end

      it 'should return public topic and it\'s public posts without authorization' do
        create(:post, { topic: @topic, is_public: true, title: 'first'})
        create(:post, { topic: @topic, is_public: true, title: 'second' })
        @topic.update(is_public: true)

        post '/graphql', params: { query: get_topic_query(topic_uuid: @topic[:uuid]) }
        json = JSON.parse(response.body)
        topic = json['data']['topic']

        expect(topic).to include(
                           "uuid" => @topic[:uuid],
                           "title" => @topic[:title],
                           "posts" => be_present
                         )
        expect(topic["posts"].length).to be(2)
      end

      it 'should return private topic and it\'s for author' do
        create(:post, { topic: @topic })
        second_post = create(:post, { topic: @topic, title: 'second' })
        create(:post, { topic: @topic, title: 'third' })

        post '/graphql', params: { query: get_topic_query(topic_uuid: @topic[:uuid]) }, headers: { Authorization: @token }
        json = JSON.parse(response.body)
        topic = json['data']['topic']

        expect(topic).to include(
                           "uuid" => @topic[:uuid],
                           "title" => @topic[:title],
                           "posts" => be_present
                         )
        expect(topic["posts"].length).to be(3)
        expect(topic["posts"][1]).to include(
                                       "uuid" => second_post[:uuid],
                                       "title" => second_post[:title],
                                       "content" => second_post[:content],
                                       "topicUuid" => @topic[:uuid]
                                     )
      end
    end
  end
end
