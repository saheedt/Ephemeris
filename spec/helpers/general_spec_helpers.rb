
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

    def topic_mutation(type, topic)
      if topic[:topic_uuid].present?
        <<~GQL
        mutation {
          #{type}(input: {
            title: "#{topic[:title]}"
            isPublic: #{topic[:is_public]}
            topicUuid: "#{topic[:topic_uuid]}"
          })
          {
            topic {
              uuid
              title
            }
          }
        }
        GQL
      else
        <<~GQL
        mutation {
          #{type}(input: {
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

    def update_post_mutation(post)
      <<~GQL
        mutation {
          updatePost(input: {
            title: "#{post[:title]}"
            content: "#{post[:content]}"
            postUuid: "#{post[:post_uuid]}"
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

    def dummy_topic_credentials(title='xyz', is_public=true, topic_uuid=nil)
      if topic_uuid
        {
          title: title,
          is_public: is_public,
          topic_uuid: topic_uuid
        }
      else
        {
          title: title,
          is_public: is_public
        }
      end
    end

    def dummy_post_credentials(topic_uuid=nil, title='test post', content='my test content')
      {
       title: title,
       content: content,
       topic_uuid: topic_uuid
      }
    end

    def dummy_post_update_credentials(post_uuid=nil, title='update post', content='update my test content')
      {
        title: title,
        content: content,
        post_uuid: post_uuid
      }
    end

    def fake_token(token = 'eyJhbGciOiJIUzI1Nikh.eyJ1dWlkIjggjMzc5OTAyYzdgMjczYy00Y2U2LWJkODMtNzQyMTNkMzI4MzkwIiwiZXhwIjoxNTc3MjE4MjQ1fQ.dhrjEf3JNf9Pa9YJXdzpAVcH9jitIsNdNOnHD7IqxSJG')
      token
    end
  end
end
