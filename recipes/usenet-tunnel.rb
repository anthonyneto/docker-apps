#
# Cookbook Name:: docker-apps
# Recipe:: usenet-tunnel
#

include_recipe 'docker-apps'

docker_image 'tutum/centos' do
  notifies :redeploy, 'docker_container[usenet-tunnel]', :immediately
end

docker_container 'usenet-tunnel' do
  repo 'tutum/centos'
  port '2222:22'
  env [
    "AUTHORIZED_KEYS=#{node['docker-apps']['usenet-tunnel']['auth-keys']}"
  ]
  # action :run
end
