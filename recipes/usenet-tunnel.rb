#
# Cookbook Name:: docker-apps
# Recipe:: usenet-tunnel
#

include_recipe 'docker-apps'

docker_image 'tutum/centos' do
  notifies :redeploy, 'docker_container[usenet-tunnel-incoming]', :immediately
end

docker_image 'kingsquare/tunnel' do
  notifies :redeploy, 'docker_container[usenet-tunnel-outgoing]', :immediately
end

docker_container 'usenet-tunnel-incoming' do
  repo 'tutum/centos'
  port '2222:22'
  env [
    "AUTHORIZED_KEYS=#{node['docker-apps']['usenet-tunnel']['auth-keys']}"
  ]
  action :run
end

user = node['docker-apps']['usenet-tunnel']['user']
host = node['docker-apps']['usenet-tunnel']['host']
ssh_port = node['docker-apps']['usenet-tunnel']['ssh-port']
local_port = node['docker-apps']['usenet-tunnel']['local-port']
tunnel_host = node['docker-apps']['usenet-tunnel']['tunnel-host']
tunnel_port = node['docker-apps']['usenet-tunnel']['tunnel-port']

docker_container 'usenet-tunnel-outgoing' do
  repo 'kingsquare/tunnel'
  command "0.0.0.0:#{local_port}:#{tunnel_host}:#{tunnel_port}
    #{user}@#{host} -p #{ssh_port}"
  binds [
    "#{node['storage']['hdd']}/apps/usenet-tunnel-outgoing:/root/.ssh:ro"
  ]
  restart_policy 'on-failure'
  action :run
end
