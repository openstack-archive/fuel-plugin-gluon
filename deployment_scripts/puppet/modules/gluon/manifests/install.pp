class gluon::install inherits gluon {

  package { 'git':
    ensure => installed,
  }

  package { 'python-pip':
    ensure => installed,
  }

  package { 'netready':
    ensure  => installed,
  }

  exec { 'setup python-etcd':
    path => "/bin:/usr/bin",
    command => "python /opt/netready/python-etcd/setup.py install",
    cwd => "/opt/netready/python-etcd",
    logoutput => true,
    unless  => "pip freeze | grep python-etcd",
  }

  exec { 'setup click':
    path => "/bin:/usr/bin",
    command => "python /opt/netready/click/setup.py install",
    cwd => "/opt/netready/click",
    logoutput => true,
    unless  => "pip freeze | grep click",
  }

  exec { 'setup gluon':
    path => "/bin:/usr/bin",
    command => "python /opt/netready/gluon/setup.py install",
    cwd => "/opt/netready/gluon",
    logoutput => true,
    unless  => "pip freeze | grep gluon",
  }

  Package <||> ->
  Exec <||>

}
