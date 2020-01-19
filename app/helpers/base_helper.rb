module BaseHelper
  class Base
    def self.parse_title(incoming_title, default_title)
      return default_title if incoming_title.blank?
      incoming_title
    end

    def self.resource_name
      self.name.split("::").last.singularize
    end

    def self.default_search_means(means="uuid")
      means
    end

    def self.strip_private(records)
      records.select{ |record| record if record[:is_public] }
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

    def self.build_topic_posts_relationship_data(topic, posts)
      {
        "uuid": topic[:uuid],
        "title": topic[:title],
        "posts": posts
      }
    end
  end
end
