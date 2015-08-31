#
# Cookbook Name:: docker-apps
# Recipe:: default
#

docker_service 'default' do
  action [:create, :start]
end
