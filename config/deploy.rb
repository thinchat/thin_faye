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

set :default_environment, {
  'PATH' => "/home/deployer/.rbenv/shims:/home/deployer/.rbenv/bin:$PATH"
}

namespace :deploy do
  desc "Start faye"
  task :start, roles: :app, except: {no_release: true} do
    run "#{current_path}/god -c faye.god"
  end
  after "deploy", "deploy:key", "deploy:start"

  desc "Push campfire key"
  task :key, roles: :app, except: {no_release: true} do
    ENV['FILES'] = 'campfire_token.rb'
    upload
  end

  desc "Restart faye"
  task :restart, roles: :app, except: {no_release: true} do
    run "#{current_path}/god restart faye_server"
  end

  desc "Stop faye"
  task :stop, roles: :app, except: {no_release: true} do
    run "#{current_path}/god stop faye_server"
  end

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
