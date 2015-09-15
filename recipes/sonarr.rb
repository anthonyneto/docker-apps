#
# Cookbook Name:: docker-apps
# Recipe:: sonarr
#

include_recipe 'docker-apps::_media'
include_recipe 'docker-apps'

docker_image 'linuxserver/sonarr' do
  notifies :redeploy, 'docker_container[sonarr]', :immediately
end

docker_container 'sonarr' do
  repo 'linuxserver/sonarr'
  port '8989:8989'
  env [
    'PUID=10000',
    'PGID=10000'
  ]
  binds [
    "#{node['storage']['hdd']}/apps/sonarr:/config",
    "#{node['storage']['hdd']}/downloads:/downloads",
    "#{node['storage']['hdd']}/media/tv:/tv"
  ]
  # action :run
end
