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
  end
end