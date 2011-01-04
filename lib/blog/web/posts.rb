require 'blog/web'
require 'blog/post'

module Blog
  class Web
    class Posts < Web
      # TODO: paginate this shit
      get '/' do
        @posts = Blog::Post.all
        haml :list
      end

      get '/new' do
        haml :new
      end

      post '/new' do
        # TODO: error capture
        # TODO: figure out why create() is returning an array!
        post = Blog::Post.create(params).first
        status 201
        # TODO: url helper?
        headers 'Location' =>  "/posts/#{post.slug}"
        body "/posts/#{post.slug}"
      end

      get '/:slug' do
        @post = Blog::Post.get(:slug) or raise(Sinatra::NotFound)
        not_found if @post.nil?
        haml :show
      end

      get '/:slug/edit' do
        @post = Blog::Post.get(:slug) rescue raise(Sinatra::NotFound)
        not_found if @post.nil?
        haml :edit
      end

      put '/:slug' do
        post = Blog::Post.get(:slug) rescue raise(Sinatra::NotFound)
        not_found if post.nil?
        # TODO: update post
        # post.update(params[:post])
        redirect "/posts/#{post.slug}"
      end

      private
        # TODO: rip this shit out into some kind of Sinatra::Nested or something
        def haml(page, *args)
          page = :"posts/#{page}" unless page == :not_found
          super(page, *args)
        end
    end
  end
end
