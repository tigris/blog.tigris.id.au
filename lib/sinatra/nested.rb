require 'sinatra/base'

module Sinatra
  class Nested < Base
    set :nested_views, 'views'
    set :nested_class_root, 'App'
    set :views, Proc.new {
      paths = self.to_s.sub(/^#{settings.nested_class_root}/, '').downcase.split(/::/).compact
      File.join(settings.root, settings.nested_views, *paths)
    }

    # TODO: overload get/post/put etc to jam the path into the route
    # TODO: overload redirect helper (and others?) to also jam the route into the url if it's relative
  end
end
