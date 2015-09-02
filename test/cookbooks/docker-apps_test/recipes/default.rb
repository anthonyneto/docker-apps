#
# Cookbook Name:: docker-apps_test
# Recipe:: default
#

directory '/data'
directory '/data/ssd'
directory '/data/storage'

include_recipe 'docker-apps::couchpotato'
docker_container 'couchpotato' do
  action :delete
end

include_recipe 'docker-apps::mumble'
docker_container 'mumble' do
  action :delete
end

include_recipe 'docker-apps::nzbget'
docker_container 'nzbget' do
  action :delete
end

include_recipe 'docker-apps::plexpy'
docker_container 'plexpy' do
  action :delete
end

include_recipe 'docker-apps::registry'
docker_container 'registry' do
  action :delete
end

include_recipe 'docker-apps::sonarr'
docker_container 'sonarr' do
  action :delete
end

include_recipe 'docker-apps::ventrilo'
docker_container 'ventrilo' do
  action :delete
end

include_recipe 'docker-apps::plex'
docker_container 'plex' do
  action :delete
end

# need to create a ssh key to pass into the usenet-tunnel
execute 'create_ssh_key' do
  command 'ssh-keygen -q -t rsa -N "" -f /root/.ssh/id_rsa'
  not_if { Chef::File.exist?('/root/.ssh/id_rsa') }
end

ruby_block 'read_ssh_pub_key' do
  block do
    node.override['docker-apps']['usenet-tunnel']['auth-keys'] = Chef::File.read('/root/.ssh/id_rsa.pub')
  end
end

include_recipe 'docker-apps::usenet-tunnel'
docker_container 'usenet-tunnel' do
  action :delete
end

# TODO: test ssh login process
# execute 'test_ssh' do
#   command 'ssh root@127.0.0.1 -p 2222 hostname'
# end
