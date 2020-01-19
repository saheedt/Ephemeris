
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
      if type == "deleteTopic"
        <<~GQL
        mutation {
          #{type}(input: {
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
      elsif type == "updateTopic"
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
            isPublic: #{post[:is_public]}
            topicUuid: "#{post[:topic_uuid]}"
          })
          {
            post {
              uuid
              title
              content
              topicUuid
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
            isPublic: #{post[:is_public]}
            postUuid: "#{post[:post_uuid]}"
          })
          {
            post {
              uuid
              title
              content
              topicUuid
            }
          }
        }
      GQL
    end

    def delete_post_mutation(post_uuid:)
      <<~GQL
        mutation {
          deletePost(input: {
            postUuid: "#{post_uuid}"
          })
          {
            post {
              uuid
              title
              content
              topicUuid
            }
          }
        }
      GQL
    end

    def get_post_query(post_uuid:)
      <<~GQL
        query {
          post(uuid: "#{post_uuid}") {
            uuid
            title
            content
            topicUuid
          }
        }
      GQL
    end

    def get_topic_query(topic_uuid:)
      <<~GQL
        query {
          topic(uuid: "#{topic_uuid}") {
            uuid
            title
            posts {
              uuid
              title
              content
              topicUuid
            }
          }
        }
      GQL
    end

    def get_user_query(user_uuid:)
      <<~GQL
        query {
          user(uuid: "#{user_uuid}") {
            uuid
            email
            screenName
            name
            topics {
              uuid
              title
              posts {
                uuid
                title
                content
                topicUuid
              }
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

    def dummy_post_credentials(topic_uuid=nil, title='test post', content='my test content', is_public=false)
      {
       title: title,
       content: content,
       is_public: is_public,
       topic_uuid: topic_uuid
      }
    end

    def dummy_post_update_credentials(post_uuid=nil, title='update post', content='update my test content', is_public=false)
      {
        title: title,
        content: content,
        is_public: is_public,
        post_uuid: post_uuid
      }
    end

    def fake_token(token = 'eyJhbGciOiJIUzI1Nikh.eyJ1dWlkIjggjMzc5OTAyYzdgMjczYy00Y2U2LWJkODMtNzQyMTNkMzI4MzkwIiwiZXhwIjoxNTc3MjE4MjQ1fQ.dhrjEf3JNf9Pa9YJXdzpAVcH9jitIsNdNOnHD7IqxSJG')
      token
    end

    def expired_token(token = "eyJhbGciOiJIUzI1NiJ9.eyJ1dWlkIjoiMzc5OTAyYzEtMjczYy00Y2U2LWJkODMtNzQyMTNkMzI4MzkwIiwiZXhwIjoxNTc3MjE4MjQ1fQ.dhrjEf3JNf9Pa9YJXdzpAVcH9jitIsNdNOnCo7IqxSM")
      token
    end

    def secondary_user
      {
        name: 'alt_user',
        screen_name: 'alt_user_p',
        email: 'alt_user@test.com',
        password: '1234567890',
        password_confirmation: '1234567890'
      }
    end
  end
end
