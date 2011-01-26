require 'haml'
require 'sinatra/base'
require 'sinatra/date'
require 'sinatra/url'
require 'blog/schema/tag'

module Blog
  class Web < Sinatra::Base
    use Rack::MethodOverride
    set :root, Blog.root
    set :haml, escape_html: true, format: :html5

    helpers do
      def tags
        Schema::Tag.all
      end
    end

    before do
      @user = 'danial'
      #@user = ENV['HTTP_USER']
    end

    get '/' do
      @posts = Post.latest(5)
      haml :'posts/list'
    end

    error Sinatra::NotFound do
      haml :not_found
    end
  end
end
