app_root = "/home/deploy/apps/chatrooomz"
root = "#{app_root}/current"
unicorn_pid = "#{app_root}/shared/tmp/pids/unicorn.pid"
old_pid = "#{unicorn_pid}.oldbin"

working_directory root

stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

pid "#{app_root}/shared/tmp/pids/unicorn.pid"

worker_processes 1
timeout 30
preload_app true

listen "#{app_root}/shared/tmp/sockets/unicorn.sock", :backlog => 64

# before_fork do |server, worker|
#   # the following is highly recomended for Rails + "preload_app true"
#   # as there's no need for the master process to hold a connection
#   if defined?(ActiveRecord::Base)
#     ActiveRecord::Base.connection.disconnect!
#   end

#   # Before forking, kill the master process that belongs to the .oldbin PID.
#   # This enables 0 downtime deploys.
#   old_pid = "#{old_pid}"
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       Process.kill("QUIT", File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#       # someone else did our job for us
#     end
#   end
# end

# after_fork do |server, worker|
#   # the following is *required* for Rails + "preload_app true",
#   if defined?(ActiveRecord::Base)
#     ActiveRecord::Base.establish_connection
#   end
# end

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{root}/Gemfile"
end

before_fork do |server, worker|
  # Disconnect since the database connection will not carry over
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end

  # Quit the old unicorn process
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # Start up the database connection again in the worker
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

# # Set environment to development unless something else is specified
# env = ENV["RAILS_ENV"] || "development"


# # Production specific settings
# if env == "production"
#   app_dir = "chatrooomz"
#   worker_processes 4
# end

# # listen on both a Unix domain socket and a TCP port,
# # we use a shorter backlog for quicker failover when busy
# listen "/tmp/unicorn.#{app_dir}.sock", :backlog => 64

# # Preload our app for more speed
# preload_app true

# # nuke workers after 30 seconds instead of 60 seconds (the default)
# timeout 30

# # Help ensure your application will always spawn in the symlinked
# # "current" directory that Capistrano sets up.
# working_directory "/home/deploy/apps/#{app_dir}/current"

# # feel free to point this anywhere accessible on the filesystem
# user 'deploy', 'deploy'
# shared_path = "/home/deploy/apps/#{app_dir}/shared"

# stderr_path "#{shared_path}/log/unicorn.stderr.log"
# stdout_path "#{shared_path}/log/unicorn.stdout.log"

# pid "#{shared_path}/tmp/pids/unicorn.pid"


# before_fork do |server, worker|
#   # the following is highly recomended for Rails + "preload_app true"
#   # as there's no need for the master process to hold a connection
#   if defined?(ActiveRecord::Base)
#     ActiveRecord::Base.connection.disconnect!
#   end

#   # Before forking, kill the master process that belongs to the .oldbin PID.
#   # This enables 0 downtime deploys.
#   old_pid = "#{shared_path}/pids/unicorn.pid.oldbin"
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       Process.kill("QUIT", File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#       # someone else did our job for us
#     end
#   end
# end

# after_fork do |server, worker|
#   # the following is *required* for Rails + "preload_app true",
#   if defined?(ActiveRecord::Base)
#     ActiveRecord::Base.establish_connection
#   end
# end