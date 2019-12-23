
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
              name
            }
            token
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
              name
            }
            token
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

    def create_post_mutation(post)
      <<~GQL
        mutation {
          createPost(input: {
            title: "#{post[:title]}"
            content: "#{post[:content]}"
            topicUuid: "#{post[:topic_uuid]}"
          })
          {
            post {
              uuid
              title
              content
            }
          }
        }
      GQL
    end

    def dummy_login_credentials(email='test@test.com', password= '1234567890')
      {
        email: email,
        password: password
      }
    end

    def dummy_topic_credentials(title='xyz', is_public=true)
      {
        title: title,
        is_public: is_public
      }
    end

    def dummy_post_credentials(topic_uuid=nil, title='test post', content='my test content')
      {
       title: title,
       content: content,
       topic_uuid: topic_uuid
      }
    end
  end
end
