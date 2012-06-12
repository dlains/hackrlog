Exec
{
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

package
{
  "nginx": ensure => present
}

service
{
  "nginx": ensure => true, enable => true
}

file
{
  "/etc/nginx/nginx.conf":
    source => "/etc/puppet/modules/nginx/nginx.conf",
    mode   => 644,
    owner  => root,
    group  => root
}

file
{
  "/etc/nginx/conf.d/hackrlog.conf":
    source => "/etc/puppet/modules/nginx/conf.d/hackrlog.conf",
    mode   => 644,
    owner  => root,
    group  => root
}