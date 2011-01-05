require 'blog/web'
require 'blog/post'

module Blog
  class Web
    # TODO: error capture
    class Posts < Web
      get '/' do
        # TODO: paginate this shit
        @posts = Schema::Post.all
        haml :list
      end

      get '/new' do
        haml :new
      end

      post '/new' do
        post = Post.create(params)
        # TODO: url helper?
        redirect "/posts/#{post.slug}"
      end

      get '/:slug' do
        @post = Post.discover(params[:slug]) or raise(Sinatra::NotFound)
        haml :show
      end

      get '/:slug/edit' do
        @post = Post.discover(params[:slug]) or raise(Sinatra::NotFound)
        haml :edit
      end

      put '/:slug' do |slug|
        Post.update(slug, params)
        redirect "/posts/#{post.slug}"
      end

      private
        # TODO: overload views root
        def haml(page, *args)
          page = :"posts/#{page}" unless page == :not_found
          super(page, *args)
        end
    end
  end
end
