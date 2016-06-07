include_recipe 'neto_server::docker'

directory '/data/apps/sync-seed'
directory '/data/apps/sync-seed/mounts'
directory '/data/apps/sync-seed/mounts/example'

cookbook_file '/data/apps/sync-seed/run.rb' do
  mode 00755
  content %Q(#!/usr/bin/env ruby
require 'net/ssh'
require 'shellwords'

ssh_user = ENV['ssh_user']
ssh_host = ENV['ssh_host']
ssh_port = ENV['ssh_port']
ssh_dir = ENV['ssh_dir']
tmp_dir = ENV['tmp_dir']

def get_remote_file_list(host, port, user, dir)
  Net::SSH.start(host, user, :port => port) do |ssh|
    stdout = ""
    ssh.exec!("find #{dir} -maxdepth 1") do |channel, stream, data|
      stdout << data if stream == :stdout
    end

    stdout = stdout.split(/\n/).reverse
  end
end

def sync_remote_to_local_tmp(host, port, user, dir, tmp_dir)
  get_remote_file_list(host, port, user, dir).each do |entry|
    break if dir == entry
    system("rsync -avz -e 'ssh -p#{port}' '#{user}@#{host}:#{Shellwords.escape(entry)}' #{tmp_dir}")
    system("ssh -p #{port} #{user}@#{host} rm -fr \"#{Shellwords.escape(entry)}\"")
  end
end

while true
  sync_remote_to_local_tmp(ssh_host, ssh_port, ssh_user, ssh_dir, tmp_dir)
  sleep 10
end)
end

file '/data/apps/sync-seed/Dockerfile' do
  content 'FROM alpine:latest
  RUN apk add --update rsync openssh-client ruby bash vim && rm -rf /var/cache/apk/*
  RUN gem install --no-ri --no-rdoc net-ssh
  RUN gem install --no-ri --no-rdoc shellwords
  RUN mkdir /data

  CMD ruby run.rb'
end

docker_image 'chef-sync-seed' do
  source '/data/apps/sync-seed/Dockerfile'
  action :build_if_missing
end

docker_container 'sync-seed-test' do
  container_name 'chef-sync-seed'
  tag 'latest'
  env [
    'ssh_host=10.0.0.100',
    'ssh_port=2222',
    'ssh_user=root',
    'ssh_dir=/data/example',
    'tmp_dir=/data'
  ]
  binds [
    '/data/keys/example:/root/.ssh',
    '/data/apps/sync-seed/run.rb:/run.rb:ro',
    '/data/apps/sync-seed/mounts/example:/data'
  ]
end
