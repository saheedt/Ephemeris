module TopicsHelper
  class Topics
    def self.create(title, is_public, user_id)
      topic = Topic.new(title: title, is_public: is_public, user_id: user_id)
      if topic.save
        {
          "topic": {
            "uuid": topic[:uuid],
            "title": topic[:title]
          }
        }
      else
        ExceptionHandlerHelper::GQLCustomError.new(topic.errors.full_messages)
      end
    end

    def self.fetch_with_relationship_by(type, relationship)
      Topic.includes(relationship).find_by(type)
    end

    def self.default_topic_search_means
      "uuid"
    end
  end
end
