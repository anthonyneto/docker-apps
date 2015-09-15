#
# Cookbook Name:: docker-apps
# Recipe:: ventrilo
#

include_recipe 'docker-apps'

docker_image 'akursar/ventrilo' do
  notifies :redeploy, 'docker_container[ventrilo]', :immediately
end

docker_container 'ventrilo' do
  repo 'akursar/ventrilo'
  port ['3784:3784/tcp', '3784:3784/udp']
  # action :run
end
