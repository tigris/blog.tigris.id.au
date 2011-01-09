require 'blog/web'
require 'blog/post'

module Blog
  class Web
    class Tags < Web
      get %r{^/(.*)$} do |tags|
        tags = tags.split(/\s|\+/)
        @posts = Blog::Post.find_by_tags(tags)
        haml :'posts/list'
      end
    end
  end
end
