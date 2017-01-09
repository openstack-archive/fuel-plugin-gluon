class gluon::install inherits gluon {

  package { 'git':
    ensure  => installed,
  }

  package { 'python-pip':
    ensure => installed,
  }

  exec { 'setup gluon':
    path => "/bin:/usr/bin",
    command => "python /opt/gluon/setup.py install",
    cwd => "/opt/gluon",
    logoutput => true,
    require => Package["python-pip"],
    unless  => "pip freeze | grep gluon",
  }

  Package <||> ->
  Exec <||>

}
