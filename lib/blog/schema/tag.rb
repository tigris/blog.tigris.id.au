module Blog
  module Schema
    class Tag < Swift::Scheme
      store :tags
      attribute :post_id, Swift::Type::Integer
      attribute :name,    Swift::Type::String

      def self.destroy(post_id, *names)
        placeholder = (['?'] * names.size).join(',')
        Blog.db.execute("delete from :tags where :post_id = ? and :name in (#{placeholder})", post_id, names)
      end
    end
  end
end
