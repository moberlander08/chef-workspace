#
# Cookbook Name:: terrepets
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#a

include_recipe "ruby"
include_recipe "nginx"
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "mysql::ruby"

mysql_database_user node['terrepets']['database'] do
        connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
        password node['terrepets']['db_password']
        database_name node['terrepets']['database']
        privileges [:select,:update,:insert,:create,:delete]
        action :grant
end
