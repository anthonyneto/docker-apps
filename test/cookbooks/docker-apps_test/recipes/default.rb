#
# Cookbook Name:: docker-apps_test
# Recipe:: default
#

directory '/data'
directory '/data/ssd'
directory '/data/storage'

include_recipe 'docker-apps::couchpotato'
include_recipe 'docker-apps::mumble'
include_recipe 'docker-apps::nzbget'
include_recipe 'docker-apps::plexpy'
include_recipe 'docker-apps::registry'
include_recipe 'docker-apps::sonarr'
include_recipe 'docker-apps::ventrilo'
include_recipe 'docker-apps::plex'

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

# TODO: test ssh login process
# execute 'test_ssh' do
#   command 'ssh root@127.0.0.1 -p 2222 hostname'
# end
