source 'https://supermarket.chef.io'

metadata

cookbook 'docker', github: 'bflad/chef-docker'

group :integration do
  cookbook 'docker-apps_test', path: 'test/cookbooks/docker-apps_test'
end
