#
# Cookbook Name:: docker-apps
# Recipe:: registry
#

include_recipe 'docker-apps'

docker_image 'registry' do
  tag '2'
  notifies :redeploy, 'docker_container[registry]', :immediately
end

docker_container 'registry' do
  tag '2'
  port '5000:5000'
  binds [
    "#{node['storage']['hdd']}/docker/registry:/var/lib/registry"
  ]
  action :run
end
