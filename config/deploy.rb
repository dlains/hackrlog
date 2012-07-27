require 'bundler/capistrano'

set :application, "hackrlog.com"
set :scm, :git
set :repository,  "git@github.com:dlains/hackrlog.git"

set :port, 14400
set :deploy_to, "/home/dave/public_html/#{application}"
set :user, "dave"
set :use_sudo, false
set :keep_releases, 3

role :web, application
role :app, application
role :db,  application, primary: true

# Access to start, stop and restart for Unicorn.
namespace :deploy do
  task :start, roles: :app do
    run "#{sudo} /etc/init.d/hackrlog start", pty: true
  end

  task :stop, roles: :app do
    run "#{sudo} /etc/init.d/hackrlog stop", pty: true
  end

  task :restart, roles: :app do
    run "#{sudo} /etc/init.d/hackrlog restart", pty: true
  end
end