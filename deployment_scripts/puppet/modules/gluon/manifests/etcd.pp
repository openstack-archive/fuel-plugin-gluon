class gluon::etcd inherits gluon
{

  file { '/usr/local/bin/etcd':
    source => '/opt/netready/etcd/etcd',
  } ->

  file { '/usr/local/bin/etcdctl':
    source => '/opt/netready/etcd/etcdctl',
  } ->

  file { '/var/lib/etcd':
    ensure => 'directory',
  } ->

  file { 'etcd upstart init file':
    ensure => 'file',
    mode => '0644',
    path => '/etc/init/etcd.conf',
    source => 'puppet:///modules/gluon/etcd.conf',
  }->

  file { 'etcd override file':
    ensure => 'file',
    mode => '0644',
    path => '/etc/init/etcd.override',
    source => 'puppet:///modules/gluon/etcd.override',
  }->

  firewall { 'etcd':
    sport => [2380, 2379],
    dport => [2380, 2379],
    chain => 'INPUT',
    proto => 'tcp',
    action => 'accept',
    provider => 'iptables',
  }->

  exec { 'save iptables':
    command => $operatingsystem ? {
      'Ubuntu' => 'invoke-rc.d iptables-persistent save'
    },
    refreshonly => true,
  }->

  service { 'etcd':
    name => 'etcd',
    ensure => 'running',
    provider => "upstart",
    require => [ File['/etc/init/etcd.conf'], File['/etc/init/etcd.override'] ],
  }->

  exec { 'check etcd status':
    path => '/usr/local/bin',
    command => 'etcdctl cluster-health',
    logoutput => true,
  }

}
