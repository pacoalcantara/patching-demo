#
# Cookbook Name:: webserver
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Compliance Demo code - Part 2

include_recipe 'iptables::default'

# Apply firewall rules.
iptables_rule 'firewall'

# Compliance Demo code - Part 2

# Install the httpd package.
  #to do --> upgrade and test (inside action)
#package 'httpd'

#%w{ bash httpd }.each do |pkg|
#  package "#{pkg}" do
#    action [ :install, :upgrade ]
#  end
#end

yum_package 'bash' do
  version '4.1.2-15'
  allow_downgrade true
end

yum_package 'httpd' do
  version '2.2.15-47'
  allow_downgrade true
end

# Enable and start the httpd service.
service 'httpd' do
  action [:enable, :start]
end

# Create the web_admin user and group.
group 'web_admin'

user 'web_admin' do
  group 'web_admin'
  system true
  shell '/bin/bash'
end

# Create the [pages] directory under the document root directory.
directory '/var/www/html/pages' do
  group 'web_admin'
  user 'web_admin'
end

# Add files to the site.
%w(index.html pages/page1.html pages/page2.html).each do |web_file|
  file File.join('/var/www/html', web_file) do
    content "<html> <body> <h1> This is file [#{web_file}] Hello World! </h1> </body> </html>"
    group 'web_admin'
    user 'web_admin'
  end
end
