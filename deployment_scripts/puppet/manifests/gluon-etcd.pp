# szilard.cserey@nokia-bell-labs.com
notice('MODULAR: gluon-etcd.pp')
include gluon

class { 'gluon::etcd': }
