require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Post model' do
    topic = nil
    before(:all) do
      create(:user)
      user = User.first
      topic_obj = dummy_topic_credentials
      topic = Topic.create!(user: user, title: topic_obj[:title], is_public: topic_obj[:is_public])
    end

    after(:all) do
      User.destroy_all
    end

    after(:each) do
      Post.destroy_all
    end

    it 'should create Post with default values if no values are supplied' do
      post = Post.create(topic: topic)
      expect(post[:title]).to eq('Untitled')
      expect(post[:content]).to eq('')
      expect(post[:uuid]).to be_present
    end

    it 'should create Post with supplied values' do
      post_obj = dummy_post_credentials(nil)
      post = Post.create(topic: topic, title: post_obj[:title], content: post_obj[:content] )
      expect(post[:title]).to eq(post_obj[:title])
      expect(post[:content]).to eq(post_obj[:content])
      expect(post[:uuid]).to be_present
    end
  end
end
