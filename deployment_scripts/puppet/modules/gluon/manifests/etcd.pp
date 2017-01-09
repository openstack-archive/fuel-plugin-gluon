class gluon::etcd inherits gluon
{
  $provider = $operatingsystem ? {
    ubuntu => 'apt',
    centos => 'yum',
  }

  package { 'etcd':
    ensure => installed,
    provider => $provider,
  }->

  file { 'etcd config':
    ensure => 'file',
    mode => '0644',
    path => '/etc/etcd/etcd.conf',
    source => 'puppet:///modules/gluon/etcd.conf',
  }->

  firewall { 'etcd':
    sport => [2380, 2379],
    dport => [2380, 2379],
    chain => 'INPUT',
    proto => tcp,
    action => 'accept',
    provider => 'iptables',
  }->

  exec { 'persist-firewall':
    command => $operatingsystem ? {
      'CentOS' => '/sbin/iptables-save > /etc/sysconfig/iptables',
    },
    refreshonly => true,
  }->

  service { 'etcd':
    name => 'etcd',
    enable => 'true',
    ensure => 'running',
    provider => 'systemd',
  }->

  exec { 'check etcd status':
    path => '/bin',
    command => '/bin/etcdctl cluster-health',
    logoutput => true,
    require => Package['etcd'],
  }

  /*
  if ($::operatingsystem == 'Ubuntu') {

  }
  elsif ($::operatingsystem == 'CentOS') {
  }
  */



}
