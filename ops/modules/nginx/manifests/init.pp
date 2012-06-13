class nginx
{
  package
  {
    "nginx": 
    ensure => present,
    before => File["/etc/nginx/nginx.conf", "/etc/nginx/conf.d/hackrlog.conf"];
  }

  file
  {
    "/etc/nginx/nginx.conf":
      source  => "/etc/puppet/modules/nginx/files/nginx.conf",
      mode    => 644,
      owner   => root,
      group   => root,
      notify  => Service["nginx"],
      require => Package["nginx"];
    "/etc/nginx/conf.d/hackrlog.conf":
      source  => "/etc/puppet/modules/nginx/files/hackrlog.conf",
      mode    => 644,
      owner   => root,
      group   => root,
      notify  => Service["nginx"],
      require => Package["nginx"];
  }

  service
  {
    "nginx":
    ensure    => true,
    enable    => true,
    subscribe => File["/etc/nginx/nginx.conf", "/etc/nginx/conf.d/hackrlog.conf"];
  }
}
