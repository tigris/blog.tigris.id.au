require 'blog/tag'

module Blog
  class Post < Class.new(Swift::Scheme) do
      attribute :id,         Swift::Type::Integer, serial: true, key: true
      attribute :slug,       Swift::Type::String
      attribute :title,      Swift::Type::String
      attribute :content,    Swift::Type::String
      attribute :created_at, Swift::Type::Time, default: proc{ Time.now }
      has_many :tags
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
      super.map{|t| t.name}.join(' ')
    end

    # TODO
    def tags=(tags)
      super(tags.split)
    end

    private
      def slug=(slug)
        super(slug)
      end
  end
end
