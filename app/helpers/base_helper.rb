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
  end
end
