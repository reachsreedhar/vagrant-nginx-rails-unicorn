# set path to application
app_dir = '/vagrant/shared/<<APPNAME>>'
shared_dir = "#{app_dir}/shared"
working_directory app_dir

# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
#listen "/home/vagrant/sockets/unicorn.sock", :backlog => 64
listen <<RAILS_PORT>>

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "/home/vagrant/pids/unicorn.pid"
