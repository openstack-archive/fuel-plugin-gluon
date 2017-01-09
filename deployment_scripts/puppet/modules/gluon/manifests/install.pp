class gluon::install inherits gluon {

  package { 'git':
    ensure => installed,
  }

  package { 'python-pip':
    ensure => installed,
  }

  package { 'gluon':
    ensure  => installed,
  }

  exec { 'setup python-etcd':
    path => "/bin:/usr/bin",
    command => "python /opt/gluon/python-etcd/setup.py install",
    cwd => "/opt/gluon/python-etcd",
    logoutput => true,
    unless  => "pip freeze | grep python-etcd",
  }

  exec { 'setup click':
    path => "/bin:/usr/bin",
    command => "python /opt/gluon/click/setup.py install",
    cwd => "/opt/gluon/click",
    logoutput => true,
    unless  => "pip freeze | grep click",
  }

  exec { 'setup gluon':
    path => "/bin:/usr/bin",
    command => "python /opt/gluon/gluon/setup.py install",
    cwd => "/opt/gluon/gluon",
    logoutput => true,
    unless  => "pip freeze | grep gluon",
  }

  Package <||> ->
  Exec <||>

}
