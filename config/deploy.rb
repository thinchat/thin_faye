require "bundler/capistrano"

server "50.116.34.44", :web, :app, :db, primary: true

set :application, "thin_faye"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:thinchat/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  desc "Start faye"
  task :start, roles: :app, except: {no_release: true} do
    sudo "god -D --log-level debug start faye_server"
  end
  after "deploy", "deploy:key"

  desc "Push campfire key"
  task :key, roles: :app, except: {no_release: true} do
    ENV['FILES'] = 'campfire_token.rb'
    upload
  end

  desc "Restart faye"
  task :restart, roles: :app, except: {no_release: true} do
    sudo "god -D --log-level debug restart faye_server"
  end

  desc "Stop faye"
  task :stop, roles: :app, except: {no_release: true} do
    sudo "god -D --log-level debug stop faye_server"
  end

  desc "Push secret files"
  task :secret, roles: :app do
    run "mkdir #{release_path}/config/secret"
    transfer(:up, "config/secret/redis_password.rb", "#{release_path}/config/secret/redis_password.rb", :scp => true)
    require "./config/secret/redis_password.rb"
    sudo "/usr/bin/redis-cli config set requirepass #{REDIS_PASSWORD}"
  end
  after "deploy:key", "deploy:secret"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end
