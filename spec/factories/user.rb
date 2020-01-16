FactoryBot.define do
  factory :user do
    screen_name { 'tester_p' }
    name { 'tester' }
    email { 'test@test.com' }
    password { '1234567890' }
    password_confirmation { '1234567890' }
  end
end