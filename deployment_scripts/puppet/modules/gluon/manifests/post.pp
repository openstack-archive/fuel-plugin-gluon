class gluon::post inherits gluon {

  group { 'proton':
    name => 'proton',
    system => true,
    ensure => present,
  } ->

  user { 'proton':
    name => 'proton',
    groups => 'proton',
    shell => '/usr/sbin/nologin',
    home => '/opt/netready',
    system => true,
    ensure => present,
  } ->

  file { [ '/etc/proton', '/var/lib/proton' ]:
    ensure => 'directory',
    owner => 'proton',
    group => 'proton',
    mode => 'go+w',
  } ->

  file { '/etc/proton/proton.conf':
    ensure => 'file',
    owner => 'proton',
    group => 'proton',
    mode => 'go+w',
    content => "[DEFAULT]
state_path = /var/lib/proton",
  } ->

  file { '/etc/proton/proton-shim.conf':
    ensure => 'file',
    owner => 'proton',
    group => 'proton',
    mode => 'go+w',
  } ->

  firewall { '000 gluon':
    sport => '2705',
    dport => '2705',
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

  if ($::operatingsystem == 'Ubuntu') {
    file { '/etc/init/proton-server.conf':
      source => '/opt/netready/gluon/scripts/proton-server.conf',
      mode => '0644',
    } ->

    file { '/etc/init.d/proton-server':
      source => '/opt/netready/gluon/scripts/proton-server',
      mode => '0755',
    } ->

    service { 'proton-server':
      ensure => "running",
      provider => "upstart",
      require => [ File['/etc/proton/proton.conf'], File['/etc/init/proton-server.conf'], File['/etc/init.d/proton-server'] ],
    }

    file { '/etc/init/proton-shim-server.conf':
      source => 'puppet:///modules/gluon/proton-shim-server.conf',
      mode => '0644',
    }->

    file { '/etc/init.d/proton-shim-server':
      source => 'puppet:///modules/gluon/proton-shim-server',
      mode => '0755',
    }->

    service { 'proton-shim-server':
      ensure => "running",
      provider => "upstart",
      require => [ File['/etc/proton/proton-shim.conf'], File['/etc/init/proton-shim-server.conf'], File['/etc/init.d/proton-shim-server'] ],
    }
  }
  elsif ($::operatingsystem == 'CentOS') {
  }

}
