#
# Cookbook Name:: docker-apps
# Recipe:: vnc
#

include_recipe 'docker-apps'

docker_image 'kaixhin/vnc' do
  notifies :redeploy, 'docker_container[vnc]', :immediately
end

docker_container 'vnc' do
  repo 'kaixhin/vnc'
  port '5901:5901/tcp'
  action :run
end
