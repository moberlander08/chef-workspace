#
# Cookbook Name:: ruby-2.1
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#install openssl and missing mysql libaries
apt_package "openssl" do
  action :install
end

apt_package "libmysqlclient-dev" do
  action :install
end

apt_package "build-essential" do
  action :install
end

if node["ruby"]["version"] == "2.2.0"
        apt_package "libffi-dev" do
        action :install
        end
end

directory node["ruby"]["path"] do
  recursive true
  action :delete
end

directory node["ruby"]["path"] do
        owner "root"
        group "root"
        mode "0755"
        action :create
        recursive true
end

#find number of cores
numberofprocs = `nproc`

`make -j #{numberofprocs.to_i + 1}`


#Setup the ruby url
ruby_latest = node['ruby']['path'] + "/" + node['ruby']['version'] +".tar.gz"
url_clean = node['ruby']['version']
clean_url = url_clean[-2,2]
ruby_url ="http://cache.ruby-lang.org/pub/ruby/" + node['ruby']['version'].chomp(clean_url) + "/ruby-" + node['ruby']['version'] + ".tar.gz"

remote_file ruby_latest do
        source ruby_url
        mode "0644"
end

execute "untar-ruby_source" do
        cwd node['ruby']['path']
        command "tar --strip-components 1 -xvf " + ruby_latest
end

#change to source directory
execute "configure-source" do
        cwd node['ruby']['path']
        user 'root'
        command "./configure"
end

execute "make-source" do
        cwd node['ruby']['path']
        user 'root'
        command "make"
end

execute "install-source" do
        cwd node['ruby']['path']
        user 'root'
        command "make install"
end

