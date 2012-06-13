class hackrlog
{
  file
  {
    ["/var/hackrlog/",
     "/var/hackrlog/shared/",
     "/var/hackrlog/shared/config/",
     "/var/hackrlog/shared/log/",
     "/var/hackrlog/shared/pids/"]:
    ensure => directory,
    owner  => vagrant,
    group  => vagrant,
    mode   => 775
  }
  
  file
  {
    "/var/hackrlog/shared/config/database.yml":
      ensure => present,
      owner  => vagrant,
      group  => vagrant,
      mode   => 600,
      source => "puppet:///modules/hackrlog/database.yml"
  }
  
  package
  {
    "bundler":
      provider => gem
  }
}