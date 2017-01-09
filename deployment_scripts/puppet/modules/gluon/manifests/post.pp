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
  }

  if ($::operatingsystem == 'Ubuntu') {
    file { '/etc/init/proton-server.conf':
      source => '/opt/netready/gluon/scripts/proton-server.conf',
    } ->

    file { '/etc/init.d/proton-server':
      source => '/opt/netready/gluon/scripts/proton-server',
    } ->

    service { 'proton-server':
      ensure => "running",
      provider => "upstart",
      require => [ File['/etc/proton/proton.conf'], File['/etc/init/proton-server.conf'], File['/etc/init.d/proton-server'] ],
    }
  }
  elsif ($::operatingsystem == 'CentOS') {
  }





}
