require 'blog/web'
require 'blog/post'

module Blog
  class Web
    class Tags < Web
      get %r{/(.*)$/} do |tags|
        tags = tags.split(/\s|\+/)
        @posts = Blog::Post.all
        haml :list
      end

    private
      # TODO: rip this shit out into some kind of Sinatra::Nested or something
      def haml(*args)
        page = args.shift
        super("tags/#{page}".to_sym, *args)
      end
  end
end
