require 'haml'
require 'coffee-script'
require 'sinatra/nested'
require 'sinatra/date'
require 'blog/schema/tag'

module Blog
  class Web < Sinatra::Base
    set :root, Blog.root
    set :haml, escape_html: true, format: :html5

    helpers do
      def tags
        Schema::Tag.all
      end
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
