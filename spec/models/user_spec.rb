require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User model' do

    after(:each) do
      User.destroy_all
    end
    it 'should create user with supplied credential' do
      user_object = {
        screen_name: 'tester_p',
        name: 'tester',
        email: 'test@test.com',
        password: '1234567890',
        password_confirmation: '1234567890'
      }
      user = User.create! user_object

      expect(user[:screen_name]).to eq(user_object[:screen_name])
      expect(user[:name]).to eq(user_object[:name])
      expect(user[:email]).to eq(user_object[:email])
      expect(user[:password_digest]).to be_present
      expect(user[:uuid]).to be_present
    end

    it 'should return right user' do
      user_object = {
        screen_name: 'tested_p',
        name: 'tested',
        email: 'secondtest@test.com',
        password: '1234567890',
        password_confirmation: '1234567890'
      }
      user = User.create! user_object

      found = User.find_by(uuid: user[:uuid])

      expect(found[:email]).to eq(user_object[:email])
      expect(found[:screen_name]).to eq(user_object[:screen_name])
      expect(found[:name]).to eq(user_object[:name])
    end

  end
end
