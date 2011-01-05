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

      get '/:slug' do |slug|
        @post = Post.discover(slug) or raise(Sinatra::NotFound)
        haml :show
      end

      get '/:slug/edit' do |slug|
        @post = Post.discover(slug) or raise(Sinatra::NotFound)
        haml :edit
      end

      put '/:slug' do |slug|
        Post.update(slug, params)
        redirect "/posts/#{post.slug}"
      end
    end
  end
end
