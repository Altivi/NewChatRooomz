# # paths
# app_path = "/home/deploy/chatrooomz"
# working_directory "#{app_path}/current"
# pid               "#{app_path}/current/tmp/pids/unicorn.pid"

# # listen
# listen "/tmp/unicorn-chatrooomz.socket", :backlog => 64

# # logging
# stderr_path "log/unicorn.stderr.log"
# stdout_path "log/unicorn.stdout.log"

# # workers
# worker_processes 3

# # use correct Gemfile on restarts
# before_exec do |server|
#   ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
# end

# set path to application
# app_dir = File.expand_path("../..", __FILE__)
# shared_dir = "#{app_dir}/shared"
# working_directory app_dir


# # Set unicorn options
# worker_processes 2
# preload_app true
# timeout 30

# # Set up socket location
# listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# # Logging
# stderr_path "#{shared_dir}/log/unicorn.stderr.log"
# stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# # Set master PID location
# pid "#{shared_dir}/pids/unicorn.pid"

# # preload
# preload_app true

# before_fork do |server, worker|
#   # the following is highly recomended for Rails + "preload_app true"
#   # as there's no need for the master process to hold a connection
#   if defined?(ActiveRecord::Base)
#     ActiveRecord::Base.connection.disconnect!
#   end

#   # Before forking, kill the master process that belongs to the .oldbin PID.
#   # This enables 0 downtime deploys.
#   old_pid = "#{server.config[:pid]}.oldbin"
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       Process.kill("QUIT", File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#       # someone else did our job for us
#     end
#   end
# end

# after_fork do |server, worker|
#   if defined?(ActiveRecord::Base)
#     ActiveRecord::Base.establish_connection
#   end
# end



# deploy_to  = "/home/deploy/chatrooomz"
# rails_root = "#{deploy_to}/current"
# pid_file   = "#{deploy_to}/shared/pids/unicorn.pid"
# socket_file= "#{deploy_to}/shared/unicorn.sock"
# log_file   = "#{rails_root}/log/unicorn.log"
# err_log    = "#{rails_root}/log/unicorn_error.log"
# old_pid    = pid_file + '.oldbin'

# timeout 30
# worker_processes 4 # Здесь тоже в зависимости от нагрузки, погодных условий и текущей фазы луны
# listen socket_file, :backlog => 1024
# pid pid_file
# stderr_path err_log
# stdout_path log_file

# preload_app true # Мастер процесс загружает приложение, перед тем, как плодить рабочие процессы.

# GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=) # Решительно не уверен, что значит эта строка, но я решил ее оставить.

# before_exec do |server|
#   ENV["BUNDLE_GEMFILE"] = "#{rails_root}/Gemfile"
# end

# before_fork do |server, worker|
#   # Перед тем, как создать первый рабочий процесс, мастер отсоединяется от базы.
#   defined?(ActiveRecord::Base) and
#   ActiveRecord::Base.connection.disconnect!

#   # Ниже идет магия, связанная с 0 downtime deploy.
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       Process.kill("QUIT", File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#       # someone else did our job for us
#     end
#   end
# end

# after_fork do |server, worker|
#   # После того как рабочий процесс создан, он устанавливает соединение с базой.
#   defined?(ActiveRecord::Base) and
#   ActiveRecord::Base.establish_connection
# end