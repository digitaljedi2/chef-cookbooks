#
# Cookbook Name:: ejabberd
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "ejabberd::#{node["ejabberd"]["install_method"]}"
