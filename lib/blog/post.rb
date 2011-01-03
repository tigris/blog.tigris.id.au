require 'blog/schema/post'
require 'blog/schema/tag'

module Blog
  class Post
    def initialize(args)
      @post = args[:post]
      @tags = args[:tags]
    end

    def tags
      @tags.map{|x| x.name}.join(' ')
    end

    # TODO: untested delegators for views to get at the data
    %w(slug title content created_at).each do |att|
      def att; @post.send(att); end
    end

    def self.get(id)
      # TODO: is there a way to get tag info as a join to save on selects
      post = id =~ /^\d+$/ ? Blog::Schema::Post.get(id) : Blog::Schema::Post.first(':slug = ?', id)
      tags = Blog::Schema::Tag.all(':post_id = ?', post.id)
    end

    def self.create(params = {})
      params = params.merge(slug: generate_slug(params[:title]))
      tags = params.delete('tags').split rescue []
      Blog.db do |db|
        db.transaction do
          post = Blog::Schema::Post.create(params).first
          # TODO: find out why swift isn't accepting the following array to create()
          # tags = Blog::Schema::Tag.create(tags.map{|t| {post_id: post.id, name: t} })

          # Also TODO: find out why this generates missing foreign key error,
          # surely the create() above on Blog::Scheme::Post generates said key?
          tags.map!{|t| Blog::Schema::Tag.create(post_id: post.id, name: t) }
        end
      end
      self.new(post: post, tags: tags)
    end

    def update(params = {})
      params = params.dup
      tags   = params.delete('tags').split rescue []
      params.delete('slug')
      Blog.db do |db|
        db.transaction do
          post = Blog::Schema::Post.update(params)
          current_tags = Blog::Schema::Tag.all(':post_id = ?', post.id)
          # TODO: the below passing of array is known to not work yet, see create() method above.
          Blog::Schema::Tag.create((tags - current_tags).map{|t| {post_id: post.id, name: t} })
          Blog::Schema::Tag.destroy(post.id, current_tags - tags)
        end
      end
    end

    private
      def self.generate_slug(title)
        title.to_s.downcase.gsub(/\s+/, '-').gsub(/[^\w-]/, '')
      end
  end
end
