require 'blog/web'
require 'blog/post'
require 'blog/schema/post'

module Blog
  class Web
    # TODO: error capture
    class Posts < Web
      get '/' do
        # TODO: paginate this shit
        @posts = Schema::Post.all
        haml :'posts/list'
      end

      get '/new' do
        haml :'posts/new'
      end

      post '/new' do
        post = Post.create(params)
        redirect url_for(:show, post)
      end

      get '/:slug' do |slug|
        @post = Post.discover(slug) or raise(Sinatra::NotFound)
        haml :'posts/show'
      end

      get '/:slug/edit' do |slug|
        @post = Post.discover(slug) or raise(Sinatra::NotFound)
        haml :'posts/edit'
      end

      put '/:slug' do |slug|
        post = Post.update(slug, params)
        redirect url_for(:show, post)
      end
    end
  end
end
