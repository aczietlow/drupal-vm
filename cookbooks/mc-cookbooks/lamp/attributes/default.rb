#
# Cookbook Name:: lamp
# Attributes:: default
#
# Copyright 2013, Mediacurrent
#
# All rights reserved - Do Not Redistribute

include_attribute "php"

# Install build-essential.
default['build_essential']['compiletime'] = true


# Mysql settings.
default['mysql']['server_root_password'] = 'password'
default['mysql']['server_debian_password'] = 'password'
default['mysql']['server_repl_password'] = 'password'

# sane settings for development environment 
# http://project.mediacurrent.com/mct/node/21400
default['mysql']['tunable']['max_allowed_packet'] = "64M"
default['mysql']['tunable']['max_connections'] = "40"
default['mysql']['tunable']['query_cache_limit'] = "8M"
default['mysql']['tunable']['query_cache_size'] = "64M"

# Custom PHP settings.
default['lamp']['php']['apache_conf_dir'] = '/etc/php5/apache2'
default['lamp']['php']['error_reporting'] = 'E_ALL'
