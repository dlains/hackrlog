require 'bundler/capistrano'

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/stripe"
load "config/recipes/monit"

server "66.175.220.122", :web, :app, :db, primary: true

set :application, "hackrlog"
set :scm, :git
set :repository,  "git@github.com:dlains/#{application}.git"
set :branch, "master"

set :port, 14400
set :user, "dave"
set :deploy_to, "/home/#{user}/public_html/#{application}.com"
set :use_sudo, false
set :keep_releases, 3

default_run_options[:pty] = true

after "deploy", "deploy:cleanup"

# Access to start, stop and restart for Unicorn.
# namespace :deploy do
#   task :start, roles: :app do
#     run "#{sudo} /etc/init.d/hackrlog start", pty: true
#   end
# 
#   task :stop, roles: :app do
#     run "#{sudo} /etc/init.d/hackrlog stop", pty: true
#   end
# 
#   task :restart, roles: :app do
#     run "#{sudo} /etc/init.d/hackrlog restart", pty: true
#   end
# end