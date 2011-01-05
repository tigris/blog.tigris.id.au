require 'blog/schema'

module Blog
  class Schema
    class Tag < Schema
      store :tags
      attribute :post_id, Swift::Type::Integer
      attribute :name,    Swift::Type::String
    end
  end
end
