UNICORN_CONFIG = {
  development: {
    socket:  '/tmp/unicorn.sock',
    pidfile: '/tmp/unicorn.pid',
    stderr:  '/tmp/unicorn.stderr.log',
    stdout:  '/tmp/unicorn.stdout.log',
    backlog: 1024,
    workers: 2
  },
}
