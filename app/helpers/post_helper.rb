module PostHelper
  class Posts < BaseHelper::Base
    EXCEPTION_HANDLER = ExceptionHandlerHelper::GQLCustomError
    RESOURCE_MSG_HELPER = MessagesHelper::Resource

    def self.create(title, content, is_public, topic)
      post = Post.new(title: title, content: content, is_public: is_public, topic_id: topic[:id])
      if post.save
       build_post_response(post, topic[:uuid])
      else
        ExceptionHandlerHelper::GQLCustomError.new(post.errors.full_messages)
      end
    end

    def self.update(model, topic_uuid, new_record)
      if model.update(new_record)
        build_post_response(model, topic_uuid)
      else
        ExceptionHandlerHelper::GQLCustomError.new(model.errors.full_messages)
      end
    end

    def self.destroy(post_record)
      topic_uuid = post_record.topic[:uuid]
      destroyed = post_record.destroy
      build_post_response(destroyed, topic_uuid)
    end

    def self.get(post_uuid, current_user = nil)
      return fetch_post_with_auth(post_uuid, current_user) if current_user.present?
      fetch_post_without_auth(post_uuid)
    end

    def self.fetch_post_with_auth(post_uuid, current_user)
      post = Post.includes(:topic).find_by("#{default_search_means}": post_uuid)
      return EXCEPTION_HANDLER.new(RESOURCE_MSG_HELPER.not_found(resource_name)) if post.blank?
      parent_topic = post.topic
      resource_owner = parent_topic.user
      return EXCEPTION_HANDLER.new(RESOURCE_MSG_HELPER.not_found(resource_name)) if !post[:is_public] && resource_owner[:uuid] != current_user[:uuid]
      return EXCEPTION_HANDLER.new(RESOURCE_MSG_HELPER.not_found(resource_name)) if !parent_topic[:is_public] && resource_owner[:uuid] != current_user[:uuid]
      build_post_query_response(post, parent_topic[:uuid])
    end

    def self.fetch_post_without_auth(post_uuid)
      post = Post.includes(:topic).find_by("#{default_search_means}": post_uuid)
      return EXCEPTION_HANDLER.new(RESOURCE_MSG_HELPER.not_found(resource_name)) if post.blank?
      parent_topic = post.topic
      return EXCEPTION_HANDLER.new(RESOURCE_MSG_HELPER.not_found(resource_name)) unless post[:is_public]
      return EXCEPTION_HANDLER.new(RESOURCE_MSG_HELPER.not_found(resource_name)) unless parent_topic[:is_public]
      build_post_query_response(post, parent_topic[:uuid])
    end

    def self.infer_visibility_status(topic_record, new_visibility_status)
      return topic_record[:is_public] unless topic_record[:is_public]
      new_visibility_status
    end

    def self.build_post_response(post_record, topic_uuid)
      {
        "post": {
          "uuid": post_record[:uuid],
          "title": post_record[:title],
          "content": post_record[:content],
          "topic_uuid": topic_uuid
        }
      }
    end

    def self.build_post_query_response(post_record, topic_uuid)
      {
        "uuid": post_record[:uuid],
        "title": post_record[:title],
        "content": post_record[:content],
        "topic_uuid": topic_uuid
      }
    end
  end
end
