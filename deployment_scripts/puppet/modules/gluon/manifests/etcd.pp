# szilard.cserey@nokia-bell-labs.com
class gluon::etcd inherits gluon
{

  $controller_ips = gluon_get_controller_mgmt_ips()
  Exec { path => ['/usr/local/bin/', '/usr/sbin/', '/usr/bin/', '/bin/'] }

  package { 'etcd':
    ensure  => installed,
  } ->

  file { '/usr/local/bin/etcd':
    source => '/opt/etcd/etcd',
    mode => '0755',
  } ->

  file { '/usr/local/bin/etcdctl':
    source => '/opt/etcd/etcdctl',
    mode => '0755',
  } ->

  file { '/var/lib/etcd':
    ensure => 'directory',
    mode => '0755',
  } ->

  file { '/var/log/etcd':
    ensure => 'directory',
    mode => '0755',
  } ->

  file { '/etc/init/etcd.conf':
    ensure => 'file',
    mode => '0644',
    source => 'puppet:///modules/gluon/etcd.conf',
  } ->

  file { '/etc/init/etcd.override':
    ensure  => file,
    mode => '0644',
    content => template('gluon/etcd.override.erb'),
  } ->

  firewall { '000 etcd':
    dport => [2379, 2380],
    chain => 'INPUT',
    proto => 'tcp',
    action => 'accept',
    provider => 'iptables',
  } ->

  exec { 'save iptables':
    command => $operatingsystem ? {
      'Ubuntu' => 'invoke-rc.d iptables-persistent save'
    },
    refreshonly => true,
  } ->

  service { 'etcd':
    name => 'etcd',
    ensure => 'running',
    provider => 'upstart',
    require => [ File['/etc/init/etcd.conf'], File['/etc/init/etcd.override'],
                 File['/var/log/etcd'], File['/var/lib/etcd'],
                 Firewall['000 etcd'] ],
  }

}
