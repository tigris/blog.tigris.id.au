require File.join(File.dirname(__FILE__), 'lib/blog')

require 'blog/web'
map('/') { run Blog::Web }

require 'blog/web/posts'
map('/posts') { run Blog::Web::Posts }
