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
      unless  => "mysqladmin -uroot -pesc4pehe11 status",
      command => "mysqladmin -uroot password esc4pehe11",
      require => Service["mysql"];
    "hackrlog_db":
      unless  => "mysql -uhackrlog -ph4ckrl0g43v3r hackrlog",
      command => "mysql -uroot -pesc4pehe11 < /etc/puppet/modules/mysql/files/hackrlog_create.sql",
      require => Exec["mysql_password"]
  }
}