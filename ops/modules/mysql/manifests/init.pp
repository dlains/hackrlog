class mysql
{
  package
  {
    "mysql-server":
      ensure  => installed,
      before  => File["/etc/mysql/my.cnf"];
  }
  
  file
  {
    "/etc/mysql/my.cnf":
      owner  => root,
      group  => root,
      mode   => 644,
      source => "/etc/puppet/modules/mysql/files/my.cnf";
  }
  
  service
  {
    "mysql":
      ensure    => running,
      subscribe => File["/etc/mysql/my.cnf"];
  }
  
  exec
  {
    "mysql_password":
      unless  => "mysqladmin -u root -p esc4pehe11 status",
      command => "mysqladmin -u root password esc4pehe11",
      require => Service["mysql"];
    "hackrlog_db":
      unless  => "mysql -u hackrlog -p h4ckrl0g43v3r hackrlog",
      command => "mysql -u hackrlog -p h4ckrl0g43v3r < /etc/puppet/modules/mysql/files/create.sql",
      require => Exec["mysql_password"]
  }
}