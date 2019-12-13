
module Helpers
  module GeneralSpecHelpers
    def create_user_mutation(user)
      <<~GQL
        mutation {
          createUser(input: {
            email: "#{user[:email]}"
            screenName: "#{user[:screen_name]}"
            password: "#{user[:password]}"
            passwordConfirmation: "#{user[:password_confirmation]}"
            name: "#{user[:name]}"
          }) {
            user {
              uuid
              email
              screenName
            }
            token
            errors
          }
        }
      GQL
    end
    def login_mutation(user)
      <<~GQL
        mutation {
          userLogin(input: {
            email: "#{user[:email]}"
            password: "#{user[:password]}"
          }) {
            user {
              uuid
              email
              screenName
            }
            token
            error
          }
        }
      GQL
    end

    def create_topic_mutation(topic)
      <<~GQL
        mutation {
          createTopic(input: {
            title: "#{topic[:title]}"
            isPublic: #{topic[:is_public]}
          })
          {
            topic {
              uuid
              title
            }
          }
        }
      GQL
    end

    def dummyLoginCredentials(email='test@test.com', password= '1234567890')
      {
        email: email,
        password: password
      }
    end

    def dummyTopicCredential(title='xyz', is_public=true)
      {
        title: title,
        is_public: is_public
      }
    end
  end
end
