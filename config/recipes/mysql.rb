namespace :mysql do
  desc "Setup mysql configuration for this application."
  task :setup, roles: :db do
    template "mysql.erb", "/tmp/mysql_conf"
    run "#{sudo} mv /tmp/mysql_conf /etc/mysql/my.cnf"
    restart
  end
  after "deploy:setup", "mysql:setup"
  
  desc "Install the MySQL backup script."
  task :install_backup, roles: :db do
    template "mysql_backup.erb", "/tmp/mysql_backup"
    run "#{sudo} mv /tmp/mysql_backup /usr/local/bin/mysql_backup"
    run "#{sudo} chmod +x /usr/local/bin/mysql_backup"
  end
  
  %w[start stop restart].each do |command|
    desc "#{command} mysql"
    task command, roles: :db do
      run "#{sudo} service mysql #{command}"
    end
  end
end