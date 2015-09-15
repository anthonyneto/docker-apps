#
# Cookbook Name:: docker-apps
# Recipe:: mumble
#

include_recipe 'docker-apps'

docker_image 'luzifer/mumble' do
  notifies :redeploy, 'docker_container[mumble]', :immediately
end

docker_container 'mumble' do
  repo 'luzifer/mumble'
  port ['64738:64738/tcp', '64738:64738/udp']
  binds [
    "#{node['storage']['hdd']}/apps/mumble/config:/config",
    "#{node['storage']['hdd']}/apps/mumble/data:/data"
  ]
  # action :run
end
