#
# Cookbook Name:: audit
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

#4.1.2-50.el6
#if defined? node[:packages][:openssl][:version] && node[:packages][:openssl][:version] < node[:openssl][:req_version]
control_group 'BASH Audit' do
  control 'BASH Version Check' do
    it 'bash version should be 4.1.2-40.el6' do
      expect(package('bash')).to be_installed.with_version('4.1.2-40.el6')
    end
  end
end
#end

#2.2.20-60.el6.centos
control_group 'HTTPD Audit' do
  control 'HTTPD Version Check' do
    it 'httpd version should be 2.2.15-53.el6.centos' do
      expect(package('httpd')).to be_installed.with_version('2.2.15-53.el6.centos')
    end
  end
end

# This is a test of audit and compliance
control_group 'Validate web services' do
  control 'Ensure no web files are owned by the root user' do
    Dir.glob('/var/www/html/**/*') {|web_file|
      it "#{web_file} is not owned by the root user" do
        expect(file(web_file)).to_not be_owned_by('root')
      end
    }
  end
end

control_group 'Validate network configuration and firewalls' do
  control 'Ensure the firewall is active' do
    it 'enables the iptables service' do
      expect(service('iptables')).to be_enabled
    end

    it 'has iptables running' do
      expect(service('iptables')).to be_running
    end

    it 'accepts SSH connections' do
      expect(iptables).to have_rule('-A INPUT -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW -j ACCEPT')
    end

    it 'accepts HTTP connections' do
      expect(iptables).to have_rule('-A INPUT -i eth0 -p tcp -m tcp --dport 80 -m state --state NEW -j ACCEPT')
    end

#    it 'rejects all other connections' do
#      expect(iptables).to have_rule('-P INPUT DROP')
#      expect(iptables).to have_rule('-P FORWARD DROP')
#    end

    it 'permits all outbound traffic' do
      expect(iptables).to have_rule('-P OUTPUT ACCEPT')
    end
  end
end
