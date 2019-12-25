module TopicsHelper
  class Topics
    def self.create(title, is_public, user_id)
      topic = Topic.new(title: title, is_public: is_public, user_id: user_id)
      if topic.save
        build_topic_response(topic)
      else
        ExceptionHandlerHelper::GQLCustomError.new(topic.errors.full_messages)
      end
    end

    def self.update(model, new_record)
      if model.update(new_record)
        build_topic_response(model)
      else
        ExceptionHandlerHelper::GQLCustomError.new(model.errors.full_messages)
      end
    end

    def self.fetch_with_relationship_by(type, *relationship)
      Topic.includes(relationship).find_by(type)
    end

    def self.default_topic_search_means(means = "uuid")
      means
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
