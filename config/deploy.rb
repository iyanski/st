# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "SmallTaskers"
set :repo_url,  "git@bitbucket.org:plussixthree/smalltaskers.git"
# set :deploy_to, "/opt/libro"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :branch, "master"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/opt/smalltaskers.net"


set :deploy_via, :copy

# Default value for :format is :airbrussh.
set :format, :airbrussh

set :rvm_ruby_version, '2.2.4@smalltaskers'
set :rvm_roles, [:app, :web]

set :assets_roles, [:web, :app]
set :assets_prefix, 'assets'
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}
set :keep_assets, 2
set :migration_role, :app

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true
set :bundle_gemfile, -> { release_path.join('Gemfile') }

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml", "config/application.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
set :default_env, { path: "/usr/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "db:seed"
        end
      end
    end
  end
  desc "Restart Passenger app"
  task :restart do
    on roles(:app) do
      within release_path do
        execute :sudo, "sudo kill $(cat /opt/nginx/logs/nginx.pid)"
        execute :sudo, "/opt/nginx/sbin/nginx"
      end
    end
  end
  desc "Restart Sidekiq"
  task :sidekiq do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          execute "RAILS_ENV=production bundle exec sidekiqctl stop tmp/sidekiq.pid 0"
          execute "RAILS_ENV=production bundle exec sidekiq -C config/sidekiq.yml -P tmp/sidekiq.pid -L log/sidekiq.log -d"
        end
      end
    end
  end
  after :finished, :restart
end