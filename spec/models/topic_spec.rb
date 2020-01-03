require 'rails_helper'

RSpec.describe Topic, type: :model do
  describe 'Topic model' do
    user = nil
    before(:all) do
      create(:user)
      user = User.first
    end

    after(:all) do
      User.destroy_all
    end

    after(:each) do
      Topic.destroy_all
    end

    it 'should create topic with default values if no values are supplied' do
      topic = Topic.create(user: user)
      expect(topic[:title]).to eq('Untitled')
      expect(topic[:is_public]).to eq(false)
      expect(topic[:uuid]).to be_present
    end

    it 'should create topic with supplied values' do
      topic = Topic.create(user: user, title: 'my test', is_public: true)
      expect(topic[:title]).to eq('my test')
      expect(topic[:is_public]).to eq(true)
      expect(topic[:uuid]).to be_present
    end

    it 'should fail if wrong data type is supplied' do
      topic = Topic.create(user: user, title: 'my test', is_public: "")
      expect(topic.errors.full_messages).to eq(["Is public can only be boolean"])
    end

  end
end
