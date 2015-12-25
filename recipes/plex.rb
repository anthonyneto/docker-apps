#
# Cookbook Name:: docker-apps
# Recipe:: plex
#

include_recipe 'docker-apps::_media'
include_recipe 'docker-apps'

docker_image 'linuxserver/plex' do
  notifies :redeploy, 'docker_container[plex]', :immediately
end

docker_container 'plex' do
  repo 'linuxserver/plex'
  network_mode 'host'
  port '32400:32400'
  env [
    "VERSION=#{node['docker-apps']['plex']['version']}",
    'PUID=10000',
    'PGID=10000'
  ]
  binds [
    "#{node['storage']['hdd']}/apps/plexmediaserver:/config",
    "#{node['storage']['ssd']}/plexmediaserver/transcoding:/config/transcoding",
    "#{node['storage']['hdd']}/media/movies:/data/movies",
    "#{node['storage']['hdd']}/media/tv:/data/tv",
    "#{node['storage']['hdd']}/media/music:/data/music",
    "#{node['storage']['hdd']}/media/photos:/data/photos",
    "#{node['storage']['hdd']}/media/videos:/data/videos"
  ]
  action :run
end
