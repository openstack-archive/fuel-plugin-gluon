class gluon::etcd inherits gluon
{

  $controller_ips = get_controller_mgmt_ips()

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
  }->

  file { '/etc/init/etcd.override':
    ensure  => file,
    mode => '0644',
    content => template('gluon/etcd.override.erb'),
  }->

  firewall { '000 etcd':
    sport => [2380, 2379],
    dport => [2380, 2379],
    chain => 'INPUT',
    proto => 'tcp',
    action => 'accept',
    provider => 'iptables',
  }->

  exec { 'save iptables':
    path => '/usr/sbin/',
    command => $operatingsystem ? {
      'Ubuntu' => 'invoke-rc.d iptables-persistent save'
    },
    refreshonly => true,
  }->

  service { 'etcd':
    name => 'etcd',
    ensure => 'running',
    provider => "upstart",
    require => [ File['/etc/init/etcd.conf'], File['/etc/init/etcd.override'], File['/var/log/etcd'], File['/var/lib/etcd'] ],
  }->

  exec { 'check etcd status':
    path => '/usr/local/bin',
    command => 'etcdctl cluster-health | grep "cluster is healthy"',
  }

}
