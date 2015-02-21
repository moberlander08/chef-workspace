#
# Cookbook Name:: percona
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node["platform_family"]
when "debian"

	execute "import percona key" do
	  command "apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A"
	  action :run
	  returns [0,1]
	end

	execute "add percona mirror" do	
	  command "echo deb http://repo.percona.com/apt VERSION main >> /etc/apt/sources.list \n echo deb-src http://repo.percona.com/apt VERSION main >> /etc/apt/sources.list"
	  action :run
	  returns [0,1]
	end

	 execute "update apt-get cached" do
          command "apt-get update"
          action :run
          returns [0,1]
        end

	apt_package "percona-xtrabackup" do
	  action :install
	end

when "rhel"

end
