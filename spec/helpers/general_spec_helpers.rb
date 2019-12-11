
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

    def create_topic_mutation topic
      <<~GQL
        mutation {
          createTopic(input: {
            title: "#{topic[:title]}"
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
  end
end
