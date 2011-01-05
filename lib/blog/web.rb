require 'haml'
require 'sinatra/nested'
require 'sinatra/date'

module Blog
  class Web < Sinatra::Nested
    set :root, Blog.root
    set :haml, escape_html: true, format: :html5
    set :nested_class_root, self

    get '/' do
      haml :home
    end

    get '/css/screen.css' do
      # TODO: print, pfft, does anyone print?
      sass :'css/screen'
    end

    error Sinatra::NotFound do
      # TODO: set a flag for Sinatra::Nested to not alter paths for error views?
      haml :not_found, :views => File.join(Blog.root, 'views')
    end
  end
end
