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
    home => '/opt/gluon',
    system => true,
    ensure => present,
  } ->

  file { [ '/etc/proton', '/opt/proton', '/var/log/proton' ]:
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
state_path = /opt/proton",
  } ->

  file { '/var/log/proton/proton-server.log':
    ensure => 'file',
    owner => 'proton',
    group => 'proton',
  }

}
