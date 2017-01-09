# szilard.cserey@nokia-bell-labs.com
notice('MODULAR: gluon-neutron-config.pp')
include gluon
$use_neutron = hiera('use_neutron', false)

if $use_neutron {
  neutron_config { 'DEFAULT/core_plugin':
    value => 'gluon.plugin.core.GluonPlugin',
    notify => Service['neutron-server'],
  }

  service { 'neutron-server':
    name => 'neutron-server',
    ensure => 'running',
    provider => 'upstart',
  }
}
