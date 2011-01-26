require 'blog/schema'

module Blog
  class Schema
    class Tag < Schema
      store :tags
      attribute :post_id, Swift::Type::Integer
      attribute :name,    Swift::Type::String

      def count
        Blog.db.execute('select count(*) as count from tags where name = ?', name).first.count.to_i
      end

      def to_s
        name
      end

      def destroy
        Blog.db.execute('delete from tags where post_id = ? and name = ?', post_id, name)
      end
    end
  end
end
