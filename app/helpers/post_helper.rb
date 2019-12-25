module PostHelper
  class Posts
    def self.create(title, content, topic_id)
      post = Post.new(title: title, content: content, topic_id: topic_id)
      if post.save
       build_post_response(post)
      else
        ExceptionHandlerHelper::GQLCustomError.new(post.errors.full_messages)
      end
    end

    def self.update(model, new_record)
      if model.update(new_record)
        build_post_response(model)
      else
        ExceptionHandlerHelper::GQLCustomError.new(model.errors.full_messages)
      end
    end

    def self.default_search_means(means="uuid")
      means
    end

    def self.build_post_response(post_record)
      {
        "post": {
          "uuid": post_record[:uuid],
          "title": post_record[:title],
          "content": post_record[:content]
        }
      }
    end
  end
end
