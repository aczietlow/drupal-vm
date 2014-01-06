#
# Cookbook Name:: example-mcdev
# Recipe:: default
#
# Copyright 2013, Mediacurrent, LLC
#
# All rights reserved - Do Not Redistribute

include_recipe "memcached"

# Add memcache pecl package.
php_pear "memcache" do
  action :install
end

# Create a mysql database.
mysql_database 'example_mcdev' do
  connection ({
    :host => 'localhost',
    :username => 'root',
    :password => node['mysql']['server_root_password']
  })
  action :create
end

# Create virtual host and enable site.
web_app node[:domain] do
  allow_override "All"
  docroot node[:docroot]
  server_aliases []
  server_name node[:domain]
end


