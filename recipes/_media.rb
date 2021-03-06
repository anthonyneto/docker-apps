#
# Cookbook Name:: docker-apps
# Recipe:: _media
#

group 'media' do
  gid '10000'
end

user 'media' do
  uid '10000'
  gid 'media'
  system true
  shell '/bin/false'
end

ruby_block 'check_storage' do
  block do
    Chef::Log.fatal('Storage directory does not exist!') unless Dir.exist?(node['storage']['hdd'])
    Chef::Log.fatal('SSD directory does not exist!') unless Dir.exist?(node['storage']['ssd'])
    fail
  end
  not_if { Dir.exist?(node['storage']['hdd']) && Dir.exist?(node['storage']['ssd']) }
end
