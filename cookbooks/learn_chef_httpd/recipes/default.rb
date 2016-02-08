#
# Cookbook Name:: learn_chef_httpd
# Recipe:: default
#
# Copyright (C) 2014
#
#
#
# same as: yum install httpd
package 'httpd'

#same as: service httpd start
service 'httpd' do
  action [:enable, :start]
end

#same as: touch /var/www/html/index.html
template '/var/www/html/index.html' do
  source 'index.html.erb'
end

#same as: service iptables stop
service 'iptables' do
  action :stop
end
