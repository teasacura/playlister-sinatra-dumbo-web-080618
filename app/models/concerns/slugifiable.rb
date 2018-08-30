module Slugifiable
  module InstanceMethods
    def slug
      self.name.downcase.split(" ").join("-")
    end
  end
  module ClassMethods
    def find_by_slug(slug)
      all.find{|obj| obj.slug == slug}
    end
  end
end
