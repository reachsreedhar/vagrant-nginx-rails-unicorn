pidfile "/home/vagrant/pids/puma.pid"

threads 2, 2
workers 10

#environment "production"
environment ENV.fetch("RAILS_ENV") { "development" }
#bind "unix:///path/to/my/app-puma.sock"
port        ENV.fetch("PORT") { <<RAILS_PORT>> }

prune_bundler

preload_app!

directory '/vagrant/shared/<<APPNAME>>'
