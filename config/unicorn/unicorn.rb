require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'blog')
require File.join(Blog.root, 'config', 'unicorn', 'config')

env = ENV['RACK_ENV'] || 'development'

options = UNICORN_CONFIG[env.to_sym]

timeout 30
pid options[:pidfile]
worker_processes options[:workers]

listen options[:socket], backlog: options[:backlog]
listen options[:port], tcp_nopush: true if options.key?(:port)

stderr_path options[:stderr] if options[:stderr]
stdout_path options[:stdout] if options[:stdout]

preload_app true
