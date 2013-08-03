# -*- encoding : utf-8 -*-
require "bundler/capistrano"

default_run_options[:pty] = true

set :default_environment, {
    'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}
set :application, "tonghaohui"
set :repository,  "git@s2.git.tonghaohui.com:s1"

set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true

server 'www.tonghaohui.com', :web, :app, :db, :primary => true

set :user, 'deployer'

set :use_sudo, false
set :deploy_to, "/home/#{user}/apps/#{application}"

set :whenever_command, "bundle exec whenever"
set :whenever_identifier, "#{application}"
require "whenever/capistrano"

after "deploy", "deploy:cleanup"

set :unicorn_path, "#{deploy_to}/current/config/unicorn.rb"

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{deploy_to}/current/; bundle exec unicorn_rails -c #{unicorn_path} -E production -D"
  end

  task :stop, :roles => :app do
    run "kill -s QUIT `cat #{deploy_to}/current/tmp/pids/unicorn.pid`"
  end

  task :restart, :roles => :app do
    run "kill -s USR2 `cat #{deploy_to}/current/tmp/pids/unicorn.pid`"
  end

  task :setup_nginx_config, :roles => :web do
    put File.read("config/nginx.conf.example"), "#{shared_path}/config/nginx.conf"
  end

  desc 'setup newrelic config'
  task :setup_newrelic_config, :roles => :app do
    put File.read("config/newrelic.yml"), "#{shared_path}/config/newrelic.yml"
  end

  desc 'setup production.local.yml'
  task :setup_production_local, :roles => :app do
    put File.read("config/settings/production.local.yml.example"), "#{shared_path}/config/settings/production.local.yml"
  end

  desc 'setup newrelic config'
  task :setup_newrelic_config, :roles => :app do
    put File.read("config/newrelic.yml"), "#{shared_path}/config/newrelic.yml"
  end
  
  desc 'setup uploads directory'
  task :setup_uploads_dir do
    run "mkdir -p #{shared_path}/public/uploads"
  end

  desc 'setup_unicorn_init_config'
  task :setup_unicorn_init_config, :roles => :web do
    put File.read("config/unicorn_init.example"), "#{shared_path}/config/unicorn_init"
    run "chmod +x #{shared_path}/config/unicorn_init"
  end

  desc 'setup_config'
  task :setup_config, roles: :app do 
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/config/settings"
    put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
    put File.read("config/unicorn.rb.example"), "#{shared_path}/config/unicorn.rb"
    setup_nginx_config
    setup_unicorn_init_config
    setup_newrelic_config
    setup_production_local
    puts "Now edit the config files in #{shared_path}."
  end

  after "deploy:setup", "deploy:setup_config", "deploy:setup_uploads_dir"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end 
  end 
  before "deploy", "deploy:check_revision"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
    run "ln -nfs #{shared_path}/config/nginx.conf #{release_path}/config/nginx.conf"
    run "ln -nfs #{shared_path}/config/unicorn_init #{release_path}/config/unicorn_init"
    run "ln -nfs #{shared_path}/public/uploads #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml"
    run "ln -nfs #{shared_path}/config/settings/production.local.yml #{release_path}/config/settings/production.local.yml"
  end

  desc "Sync the public/assets directory."
  task :assets_sync do
    system('bundle exec rake assets:precompile')
    find_servers(:roles => :web).each do |s|
      system "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{s}:#{release_path}/public/"
    end
    system('rm -rf public/assets')
  end

  task :precompile_assets, :roles => :web do 
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end

  after "deploy:update_code", "deploy:symlink_config", "deploy:assets_sync", "deploy:migrate"
end
