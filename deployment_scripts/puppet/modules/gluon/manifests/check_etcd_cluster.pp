# szilard.cserey@nokia-bell-labs.com
class gluon::check_etcd_cluster inherits gluon
{

  Exec { path => ['/usr/local/bin/', '/bin/'] }

  exec { 'check etcd status':
    command => 'etcdctl cluster-health | grep "cluster is healthy"',
  }

}
