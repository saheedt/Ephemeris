module TopicsHelper
  class Topics < BaseHelper::Base
    EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
    RESOURCE_MSG_HELPER = MessagesHelper::Resource

    def self.create(title, is_public, user_id)
      topic = Topic.new(title: title, is_public: is_public, user_id: user_id)
      if topic.save
        build_topic_response(topic)
      else
        ExceptionHandlerHelper::GQLCustomError.new(topic.errors.full_messages)
      end
    end

    def self.update(model, new_record)
      model.posts.update_all(is_public: new_record[:is_public]) unless new_record[:is_public]
      if model.update(new_record)
        build_topic_response(model)
      else
        ExceptionHandlerHelper::GQLCustomError.new(model.errors.full_messages)
      end
    end

    def self.destroy(topic_record)
      destroyed = topic_record.destroy
      build_topic_response(destroyed)
    end

    def self.get(topic_record, current_user_uuid = nil)
      return EXCEPTION_HANDLER.new(RESOURCE_MSG_HELPER.not_found(resource_name)) if topic_record.blank?
      return fetch_topic_with_auth(topic_record, current_user_uuid) if current_user_uuid.present?
      fetch_topic_without_auth(topic_record)
    end

    def self.fetch_topic_with_auth(topic_record, current_user_uuid)
      resource_owner = topic_record.user
      is_resource_owner = resource_owner[:uuid] === current_user_uuid
      return EXCEPTION_HANDLER.new(RESOURCE_MSG_HELPER.not_found(resource_name)) if !topic_record[:is_public] && !is_resource_owner
      return build_topic_query_response(topic_record, is_resource_owner)
    end

    def self.fetch_topic_without_auth(topic_record)
      return EXCEPTION_HANDLER.new(RESOURCE_MSG_HELPER.not_found(resource_name)) unless topic_record[:is_public]
      build_topic_query_response(topic_record)
    end

    def self.fetch_with_relationship_by(type, *relationship)
      Topic.includes(relationship).find_by(type)
    end

    def self.build_topic_query_response(topic_record, is_resource_owner = false)
      posts = build_topic_posts_response(strip_private(topic_record.posts), topic_record[:uuid]) unless is_resource_owner
      posts = build_topic_posts_response(topic_record.posts, topic_record[:uuid]) if is_resource_owner
      {
        "uuid": topic_record[:uuid],
        "title": topic_record[:title],
        "posts": posts
      }
    end

    def self.build_topic_posts_response(post_records, topic_uuid)
      post_records.map do |post|
        {
          "uuid": post[:uuid],
          "title": post[:title],
          "content": post[:content],
          "topic_uuid": topic_uuid
        }
      end
    end

    def self.build_topic_response(topic_record)
      {
        "topic": {
          "uuid": topic_record[:uuid],
          "title": topic_record[:title]
        }
      }
    end
  end
end
