module PostHelper
  class Posts
    def self.create(title, content, topic_id)
      post = Post.new(title: title, content: content, topic_id: topic_id)
      if post.save
       {
         "post": {
           "uuid": post[:uuid],
           "title": post[:title],
           "content": post[:content]
         }
       }
      else
        ExceptionHandlerHelper::GQLCustomError.new(post.errors.full_messages)
      end
    end
  end
end
