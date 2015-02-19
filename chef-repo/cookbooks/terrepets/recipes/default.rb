#
# Cookbook Name:: terrepets
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#a

#include_recipe "ruby"
include_recipe "bitbucket"
include_recipe "unicorn"
include_recipe "nginx"
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "mysql::ruby"

template '/etc/nginx/sites-available/terrepets.conf' do
	source 'app.erb'
	mode 0755
	owner 'root'
	group 'root'
end

execute "enable site" do
	command "ln -s /etc/nginx/sites-available/terrepets.conf /etc/nginx/sites-enabled/terrepets.conf"
end

mysql_database 'rails_dev' do
  connection(
    #:host     => '192.168.0.38',
    :username => 'root',
    :socket => "/var/run/mysqld/mysqld.sock",
    :password => node['mysql']['server_root_password']
  )
  action :create
end


mysql_database_user 'rails' do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password '*3B6C49228C0076021E2FEA035DFA8FBEC29668CA'
  database_name 'rails_dev'
  host '%'
  privileges [:all]
  action :grant
end

execute "rake db:migrate" do
  cwd "/home/rails/terrepets/"
  command "rake db:migrate"
  action :run
  #returns [0,1]
end


execute "rake db:seed" do
  cwd "/home/rails/terrepets/"
  command "rake db:seed"
  action :run
  returns [0,1]
end
