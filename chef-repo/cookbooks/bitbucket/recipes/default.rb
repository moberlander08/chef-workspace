#
# Cookbook Name:: bitbucket
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#create user account
user node["bitbucket"]["user"] do
        shell "/bin/bash"
        name node["bitbucket"]["user"]
        home "/home/"+ node["bitbucket"]["user"]
end

directory node["bitbucket"]["home"] do
        owner node["bitbucket"]["user"]
        group node["bitbucket"]["user"]
        mode "0755"
        action :create
        recursive true
end

directory node["bitbucket"]["home"] + '/.ssh' do
        owner node["bitbucket"]["user"]
        group node["bitbucket"]["user"]
        mode "0700"
        action :create
        recursive true
end

template node["bitbucket"]["home"] + '/.ssh/config' do
        source 'config.erb'
        mode "0600"
        owner node["bitbucket"]["user"]
	group node["bitbucket"]["user"]
end

template node["bitbucket"]["home"] + '/.bashrc' do
        source 'bashrc.erb'
        mode "0640"
        owner node["bitbucket"]["user"]
        group node["bitbucket"]["user"]
end

template node["bitbucket"]["home"] + '/.ssh/id_rsa' do
        source 'id_rsa.erb'
        mode "0600"
        owner node["bitbucket"]["user"]
        group node["bitbucket"]["user"]
end

template node["bitbucket"]["home"] + '/.ssh/known_hosts' do
        source 'known_hosts.erb'
        mode "0655"
        owner node["bitbucket"]["user"]
        group node["bitbucket"]["user"]
end

execute "git clone" do
  user node["bitbucket"]["user"]
  cwd  node["bitbucket"]["home"]
  command "git clone git@bitbucket.org:terrepets/terrepets.git" 
  action :run
end

execute "chown git" do
  command "chown -R " + node["bitbucket"]["user"] + ":" + node["bitbucket"]["user"] + " "+ node["bitbucket"]["home"] +"/terrepets"
  action :run
end

