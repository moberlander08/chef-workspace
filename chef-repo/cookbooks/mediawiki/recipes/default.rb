#
# Cookbook Name:: mediawiki
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"
include_recipe "mysql::ruby"

apache_site "default" do
  enable false
end


mysql_database node['mediawiki']['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['mediawiki']['database'] do
        connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
        password node['mediawiki']['db_password']
        database_name node['mediawiki']['database']
        privileges [:all]
        action :grant
end

wordpress_latest = Chef::Config[:file_cache_path] + "/mediawiki-latest.tar.gz"

remote_file wordpress_latest do
        source "https://releases.wikimedia.org/mediawiki/1.24/mediawiki-1.24.1.tar.gz"
        mode "0644"
end

directory node["mediawiki"]["path"] do
        owner "root"
        group "root"
        mode "0755"
        action :create
        recursive true
end

execute "untar-wordpress" do
        cwd node['mediawiki']['path']
        command "tar --strip-components 1 -xvf " + wordpress_latest
end

#template node['mediawiki']['path'] + '/LocalSettings.php' do
#  source 'LocalSettings.php.erb'
#  mode 0755
#  owner 'root'
#  group 'root'
#  variables(
#    :database        => node['mediawiki']['database'],
#    :user            => node['mediawiki']['db_username'],
#    :password        => node['mediawiki']['db_password'])
#end

web_app 'mediawiki' do
        template 'site.conf.erb'
        docroot node['mediawiki']['path']
        server_name node['mediawiki']['server_name']
end

