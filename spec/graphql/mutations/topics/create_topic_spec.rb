require 'rails_helper'
module Mutations
  module Topics
    RSpec.describe CreateTopic, type: :request  do
      describe '.resolve' do
        before(:all) do
          create(:user)
        end

        after(:all) do
          User.destroy_all
        end

        it 'should not successfully create a topic' do
          topic = { title: 'xyz', is_public: true }
          post '/graphql', params: { query: create_topic_mutation(topic) }

          json = JSON.parse(response.body)
          error = json['errors'][0]
          expect(error).to include( "message" => MessagesHelper::Auth.token_verification_error )
        end
      end
    end
  end
end
