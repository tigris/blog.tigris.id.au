require 'blog/schema/post'
require 'blog/schema/tag'

module Blog
  module Post
    class << self
      def discover(identifier)
        field = identifier =~ /^\d+$/ ? :id : :slug
        Schema::Post.first("#{field} = ?", identifier)
      end

      def create(params = {})
        params = params.merge(slug: generate_slug(params[:title]))
        tags = params.delete('tags').split rescue []
        post = nil
        Blog.db do |db|
          db.transaction do
            post = Schema::Post.create(params).first
            db.create Schema::Tag, *tags.map{|t| {post_id: post.id, name: t} }
          end
        end
        post
      end

      def update(identifier, params = {})
        post = search(identifier)
        params = params.dup
        tags   = params.delete('tags').split rescue []
        Blog.db do |db|
          db.transaction do
            post = Schema::Post.update(params)
            current_tags = Schema::Tag.all(':post_id = ?', post.id)
            db.create Schema::Tag, *(tags - current_tags).map{|t| {post_id: post.id, name: t} }
            db.destroy Schema::Tag, *(current_tags - tags).map{|t| {post_id: post.id, name: t} }
          end
        end
        post
      end

      private
        def generate_slug(title)
          title.to_s.downcase.gsub(/\s+/, '-').gsub(/[^\w-]/, '')
        end
    end
  end
end
