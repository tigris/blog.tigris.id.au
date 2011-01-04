module Sinatra
  class Base
    module Date
      def date_humanized(date)
        date.strftime("on %B %d, %Y at %H:%M")
      end

      def date_iso8601(date)
        date.strftime("%Y-%m-%dT%H:%M:%SZ")
      end
    end

    helpers Date
  end
end
