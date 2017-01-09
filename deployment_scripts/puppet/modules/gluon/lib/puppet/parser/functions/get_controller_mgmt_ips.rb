module Puppet::Parser::Functions
  newfunction(:get_controller_mgmt_ips, :type => :rvalue) do |args|

    fqdn = function_hiera(['fqdn'])

    net_meta = function_hiera(['network_metadata'])
    nodes = net_meta['nodes'].values

    cluster = Hash.new
    cluster_ips = Array.new
    nodes.each do |node|
      if node['fqdn'].eql? fqdn then
        cluster['current'] = node['network_roles']['management']
        cluster_ips << node['network_roles']['management']
        next
      end

      if node['fqdn'] != fqdn && ((node['node_roles'].include? 'controller') || (node['node_roles'].include? 'primary-controller')) then
         cluster_ips << node['network_roles']['management']
      end
    end

    cluster_ips.sort!

    i = 0
    cluster['all'] = {}
    cluster_ips.each do |ip|
      i += 1
      cluster['all'].merge!({i.to_s => ip})
    end

    return cluster
  end
end
