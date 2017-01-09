# szilard.cserey@nokia-bell-labs.com
notice('MODULAR: gluon-check-etcd-cluster.pp')
include gluon

class { 'gluon::check_etcd_cluster': }
