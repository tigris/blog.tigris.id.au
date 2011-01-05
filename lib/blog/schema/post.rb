require 'blog/schema'

module Blog
  class Schema
    class Post < Schema
      store :posts
      attribute :id,         Swift::Type::Integer, serial: true, key: true
      attribute :slug,       Swift::Type::String
      attribute :title,      Swift::Type::String
      attribute :content,    Swift::Type::String
      attribute :created_at, Swift::Type::Time, default: proc{ Time.now }

      def tags
        Blog.db.execute('select name from tags where post_id = ?', id).map{|x| x[:name]}.join(' ')
      end
    end
  end
end
