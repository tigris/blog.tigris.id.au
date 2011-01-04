require 'blog/tag'
require 'blog/post_tag'

module Blog
  class Post < Class.new(Swift::Scheme) do
      store :posts
      attribute :id,         Swift::Type::Integer, serial: true, key: true
      attribute :slug,       Swift::Type::String
      attribute :title,      Swift::Type::String
      attribute :content,    Swift::Type::String
      attribute :created_at, Swift::Type::Time, default: proc{ Time.now }
    end

    def self.get(id)
      id =~ /^\d+$/ ? super(id) : first(':slug = ?', id)
    end

    def title=(title)
      self.slug = title.downcase.gsub(/\s+/, '-').gsub(/[^\w-]/, '') if slug.nil?
      super(title)
    end

    # TODO: this should be able to be done with swift-more associations, eventually

    def tags
      @tags ||= PostTag.all(':post_id = ?', id).map{|x| x.tag}
    end

    def tags=(tags)
      tags = tags.split.map{|t| Tag.first(':name = ?', t) || Tag.create(name: t) } if tags.is_a?(String)

      added_tags   = tags - self.tags
      removed_tags = self.tags - tags

      # TODO: this shit needs to be done in some kind of on_save hook or
      # something, since the ID needs to exist.
      Blog.db do |db|
        st = db.prepare('insert into posts_tags (post_id, tag_id) values(?, ?)')
        added_tags.each{|t| st.execute(id, t.id) }
        st = db.prepare('delete from posts_tags where post_id = ? and tag_id = ?')
        removed_tags.each{|t| st.execute(id, t.id) }
      end

      @tags = tags
    end

    private
      def slug=(slug)
        super(slug)
      end
  end
end
