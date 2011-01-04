require 'blog/tag'

module Blog
  class Post < Class.new(Swift::Scheme) do
      attribute :id,         Swift::Type::Integer, serial: true, key: true
      attribute :slug,       Swift::Type::String
      attribute :title,      Swift::Type::String
      attribute :content,    Swift::Type::String
      attribute :created_at, Swift::Type::Time, default: proc{ Time.now }
    end
    store :posts

    def self.get(id)
      id =~ /^\d+$/ ? super(id) : first(':slug = ?', id)
    end

    def title=(title)
      self.slug = title.downcase.gsub(/\s+/, '-').gsub(/[^\w-]/, '') if slug.nil?
      super(title)
    end

    def tags
      @tags ||= Blog.db.execute('select name from tags where post_id = ?', id).join(' ')
    end

    def tags=(tags)
      tags = tags.join(' ') if tags.is_a?(Array)
      @tags = tags
    end

    def create(*args)
      Blog.db.transaction do |db|
        super(*args)
        update_tags_association
      end
      self
    end

    def update(*args)
      Blog.db.transaction do |db|
        super(*args)
        update_tags_association
      end
      self
    end

    private
      def slug=(slug)
        super(slug)
      end

      def update_tags_association
        current_tags = Blog.db.execute('select name from tags where post_id = ?', id)
        added_tags   = @tags - current_tags
        removed_tags = current_tags - @tags
        if !removed_tags.empty?
          delete = Blog.db.prepare('delete from tags where :post_id = ? and :name = ?')
          removed_tags.each{|t| delete.execute(t) }
        end
        if !added_tags.empty?
          insert = dp.prepare('insert into tags (post_id, tag) values(?, ?)')
          added_tags.each{|t| insert.execute(t) }
        end
      end
  end
end
