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

Chef::Log.fatal('Storage directory does not exist!') unless Dir.exist?(node['storage']['hdd'])
Chef::Log.fatal('SSD directory does not exist!') unless Dir.exist?(node['storage']['ssd'])
