require 'ext/string'

module Sinatra
  class Base
    module Url
      def url_for(action, object, params = {})
        id = case
          when params.key?(:id)          then params[:id]
          when object.respond_to?(:slug) then object.slug
          when object.respond_to?(:id)   then object.id
          else                                nil
        end
        route = case object
          when Symbol then object.to_s.plural
          when String then object.plural
          else             object.class.to_s.sub(/^.*::/, '').downcase.plural
        end
        action = case action.to_sym
          when :show   then nil
          when :list   then nil
          when :update then nil
          else              action
        end
        '/' + [route, id, action].compact.join('/')
      end
    end

    helpers Url
  end
end
