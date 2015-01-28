#
# Cookbook Name:: uniorn
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "ruby"

if node[:platform_family].include?("debian")

	apt_package "libmysqlclient-dev" do
		action :install
	end

	execute "install rails" do
		user 'root'
		command "gem install rails --no-ri --no-rdoc"
	end

end

#create user account
user node["unicorn"]["user"] do
	shell "/bin/bash"
	name node["unicorn"]["user"]
	home "/home/"+ node["unicorn"]["user"]
end

directory node["unicorn"]["home"] do
        owner node["unicorn"]["user"]
        group node["unicorn"]["user"]
        mode "0755"
        action :create
        recursive true
end

directory node["unicorn"]["path"] do
        owner node["unicorn"]["user"]
        group node["unicorn"]["user"]
        mode "0755"
        action :create
        recursive true
end

directory node["unicorn"]["path"] + "/log" do
        owner node["unicorn"]["user"]
        group node["unicorn"]["user"]
        mode "0755"
        action :create
        recursive true
end

directory node["unicorn"]["path"] + "/pids" do
        owner node["unicorn"]["user"]
        group node["unicorn"]["user"]
        mode "0755"
        action :create
        recursive true
end

template node["unicorn"]["path"] + '/unicorn.conf' do
	source 'unicorn.conf.erb'
	mode 755
	owner node['unicorn']['user']
	group node['unicorn']['user']
	variables(
	:user => node['unicorn']['user'],
	:workingdirectory => node['unicorn']['user'],
	:unicorndirectory => node['unicorn']['path'])
end
