require File.join(File.dirname(__FILE__), '..', 'blog')
require 'haml'
require 'sinatra/base'
require 'sinatra/date'

module Blog
  class Web < Sinatra::Base
    set :root, Blog.root
    set :haml, escape_html: true, format: :html5

    get '/' do
      haml :home
    end

    get '/css/screen.css' do
      # TODO: print, pfft, does anyone print?
      scss :'css/screen.css'
    end

    error Sinatra::NotFound do
      haml :not_found
    end
  end
end
