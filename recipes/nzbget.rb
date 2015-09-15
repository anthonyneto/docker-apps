#
# Cookbook Name:: docker-apps
# Recipe:: nzbget
#

include_recipe 'docker-apps::_media'
include_recipe 'docker-apps'

docker_image 'linuxserver/nzbget' do
  notifies :redeploy, 'docker_container[nzbget]', :immediately
end

docker_container 'nzbget' do
  repo 'linuxserver/nzbget'
  port '6789:6789'
  env [
    'PUID=10000',
    'PGID=10000'
  ]
  binds [
    "#{node['storage']['hdd']}/apps/nzbget:/config",
    "#{node['storage']['hdd']}/downloads:/downloads"
  ]
  # action :run
end
