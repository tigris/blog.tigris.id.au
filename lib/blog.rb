root = File.join(File.dirname(__FILE__), '..')
$:.unshift File.join(root, 'lib')

# Bundler.
require 'bundler'
Bundler.setup(:default) # only adds lib paths for gems in the "default" group

require 'swift'
require 'swift/more'
Swift.setup(:default, Swift::DB::Postgres, db: 'blog')

module Blog
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  def self.db(*args, &block)
    Swift.db(*args, &block)
  end
end
