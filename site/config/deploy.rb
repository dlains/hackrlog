require 'bundler/capistrano'

set :application, "hackrlog"
set :scm, :git
set :repository,  "git@github.com:dlains/hackrlog.git"

set :port, 14400
set :deploy_to, "/home/dave/public_html/#{application}"
set :user, "dave"
set :use_sudo, false
set :deploy_via, :copy
set :copy_strategy, :export
set :keep_releases, 3

role :web, application
role :app, application
role :db,  application, :primary => true

# Access to start, stop and restart for Unicorn.
namespace :deploy do
  task :start, :roles => :app do
    run "#{sudo} /etc/init.d/hackrlog start", :pty => true
  end

  task :stop, :roles => :app do
    run "#{sudo} /etc/init.d/hackrlog stop", :pty => true
  end

  task :restart, :roles => :app do
    run "#{sudo} /etc/init.d/hackrlog restart", :pty => true
  end
end