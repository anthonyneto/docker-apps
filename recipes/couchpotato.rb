#
# Cookbook Name:: docker-apps
# Recipe:: couchpotato
#

include_recipe 'docker-apps::_media'
include_recipe 'docker-apps'

docker_image 'linuxserver/couchpotato' do
  notifies :redeploy, 'docker_container[couchpotato]', :immediately
end

docker_container 'couchpotato' do
  repo 'linuxserver/couchpotato'
  port '5050:5050'
  env [
    'PUID=10000',
    'PGID=10000'
  ]
  binds [
    "#{node['storage']['hdd']}/apps/couchpotato:/config",
    "#{node['storage']['hdd']}/downloads:/downloads",
    "#{node['storage']['hdd']}/media/movies:/movies"
  ]
  # action :run
end
