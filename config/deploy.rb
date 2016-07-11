# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'chatrooomz'
set :repo_url, 'git@54.235.152.220:web/trainee-alex-tishchenko-chat.git'
set :deploy_to, '/home/deploy/apps/chatrooomz'
#set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}
set :branch, :development

set :pty, true
set :use_sudo, false
set :bundle_binstubs, nil
# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
set :format, :airbrussh

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, %w{config/database.yml config/application.yml config/private_pub.yml config/private_pub_thin.yml config/dropbox.yml}
# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :private_pub_pid, -> { "/home/deploy/apps/chatrooomz/current/tmp/pids/private_pub.pid" }

# Default settings
# set :foreman_use_sudo, false # Set to :rbenv for rbenv sudo, :rvm for rvmsudo or true for normal sudo
# set :foreman_roles, :all
# set :foreman_template, 'upstart'
# set :foreman_options, ->{ {
#   user: 'deploy',
#   log: File.join(shared_path, 'log')
# } }


# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:stop'
      invoke 'unicorn:start'
      #invoke 'foreman:setup'
      #run "cd #{deploy_to}/current && bundle exec rackup private_pub.ru -s thin -E production "
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

namespace :private_pub do
  # desc "Start private_pub server"
  # task :start do
  #   on roles(:app) do
  #     within release_path do
  #         execute :bundle, "exec rackup private_pub.ru -s thin -E production -D -P #{fetch(:private_pub_pid)}"
  #     end
  #   end
  # end

  # desc "Stop private_pub server"
  # task :stop do
  #   on roles(:app) do
  #     within release_path do
  #       execute "if [ -f #{fetch(:private_pub_pid)} ] && [ -e /proc/$(cat #{fetch(:private_pub_pid)}) ]; then kill -9 `cat #{fetch(:private_pub_pid)}`; fi"
  #     end
  #   end
  # end

  # desc "Restart private_pub server"
  # task :restart do
  #   on roles(:app) do
  #     invoke 'private_pub:stop'
  #     invoke 'private_pub:start'
  #   end
  # end
  desc "Start private_pub server"
  task :start do
    on roles(:app) do
      within release_path do
          execute :bundle, "exec thin -C config/private_pub_thin.yml -R private_pub.ru start"
      end
    end
  end

  desc "Stop private_pub server"
  task :stop do
    on roles(:app) do
      within current_path do
        execute "if [ -f #{fetch(:private_pub_pid)} ] && [ -e /proc/$(cat #{fetch(:private_pub_pid)}) ]; then kill -9 `cat #{fetch(:private_pub_pid)}`; fi"
      end
    end
  end

  desc "Restart private_pub server"
  task :restart do
    on roles(:app) do
      invoke 'private_pub:stop'
      invoke 'private_pub:start'
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
