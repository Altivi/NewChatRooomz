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
set :linked_files, %w{config/database.yml config/application.yml}
# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default settings
set :foreman_use_sudo, false # Set to :rbenv for rbenv sudo, :rvm for rvmsudo or true for normal sudo
set :foreman_roles, :all
set :foreman_template, 'upstart'
set :foreman_export_path, ->{ File.join(Dir.home, '.init') }
set :foreman_options, ->{ {
  user: 'deploy',
  log: File.join(shared_path, 'log')
} }


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
      invoke 'foreman:setup'
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