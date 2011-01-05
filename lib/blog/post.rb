require 'blog/schema/post'
require 'blog/schema/tag'

module Blog
  module Post
    class << self
      def search(identifier)
        Schema::Post.all(':id = ? or :slug = ?', identifier, identifier)
      end

      def create(params = {})
        params = params.merge(slug: generate_slug(params[:title]))
        tags = params.delete('tags').split rescue []
        Blog.db.transaction do
          post = Schema::Post.create(params).first
          # TODO: find out why swift isn't accepting the following array to create()
          # tags = Schema::Tag.create(tags.map{|t| {post_id: post.id, name: t} })

          # Also TODO: find out why this generates missing foreign key error,
          # surely the create() above on Scheme::Post generates said key?
          tags.map!{|t| Schema::Tag.create(post_id: post.id, name: t) }
        end
      end

      def update(identifier, params = {})
        post = search(identifier)
        params = params.dup
        tags   = params.delete('tags').split rescue []
        Blog.db.transaction do
          post = Schema::Post.update(params)
          current_tags = Schema::Tag.all(':post_id = ?', post.id)
          # TODO: the below passing of array is known to not work yet, see create() method above.
          Schema::Tag.create((tags - current_tags).map{|t| {post_id: post.id, name: t} })
          Schema::Tag.destroy(post.id, current_tags - tags)
        end
      end

      private
        def generate_slug(title)
          title.to_s.downcase.gsub(/\s+/, '-').gsub(/[^\w-]/, '')
        end
    end
  end
end
