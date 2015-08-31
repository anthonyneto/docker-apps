#
# Cookbook Name:: docker-apps
# Recipe:: plexpy
#

include_recipe 'docker-apps::_media'
include_recipe 'docker-apps'

docker_image 'linuxserver/plexpy' do
  notifies :redeploy, 'docker_container[plexpy]', :immediately
end

docker_container 'plexpy' do
  repo 'linuxserver/plexpy'
  port '8181:8181'
  env [
    'PUID=10000',
    'PGID=10000'
  ]
  binds [
    "#{node['storage']['hdd']}/apps/plexpy:/config",
    "#{node['storage']['hdd']}/apps/plexmediaserver/Library/Application Support/Plex Media Server/Logs:/logs:ro"
  ]
end
