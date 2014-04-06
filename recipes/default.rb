#
# Cookbook Name:: sssd_ad
# Recipe:: default
#
# Copyright 2013, Limelight Networks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
  package 'sssd' do
    action :install
  end

  # Have authconfig enable SSSD in the pam files
  execute 'pam-auth-update' do
    command 'pam-auth-update --package'
    action :nothing
  end

  if node['sssd_ad'].attribute?('krb5_url')
    remote_file "/etc/krb5.conf" do
      source node['sssd_ad']['krb5_url']
      owner 'root'
      group 'root'
      mode 00644
    end
  else
    template '/etc/krb5.conf' do
      source 'krb5.conf.erb'
      owner 'root'
      group 'root'
      mode 00644
      variables(
        :realm => node['sssd_ad']['realm'],
        :domain => node['sssd_ad']['domain']
      )
    end
  end

  if node['sssd_ad'].attribute?('smb_url')
    remote_file "/etc/samba/smb.conf" do
      source node['sssd_ad']['smb_url']
      owner 'root'
      group 'root'
      mode 00644
    end
  else
    template '/etc/samba/smb.conf' do
      source 'smb.conf.erb'
      owner 'root'
      group 'root'
      mode 00644
      variables(
        :workgroup => node['sssd_ad']['workgroup'],
        :realm => node['sssd_ad']['realm']
      )
    end
  end

  if node['sssd_ad'].attribute?('sssd_url')
    remote_file "/etc/samba/sssd.conf" do
      source node['sssd_ad']['sssd_url']
      owner 'root'
      group 'root'
      mode 00644
    end
  else
    template '/etc/sssd/sssd.conf' do
      source 'sssd.conf.erb'
      owner 'root'
      group 'root'
      mode 00600
      variables(
        :domain => node['sssd_ad']['domain']
      )

    end
  end

  if node['sssd_ad'].attribute?('mkhomedir_url')
    remote_file "/usr/share/pam-configs/my_mkhomedir" do
      source node['sssd_ad']['mkhomedir_url']
      owner 'root'
      group 'root'
      mode 00644
    end
  else
    cookbook_file '/usr/share/pam-configs/my_mkhomedir' do                                              
      source 'my_mkhomedir'                                                        
      owner 'root'                                                                 
      group 'root'                                                                 
      mode 00644                                                                   
      notifies :run, 'execute[pam-auth-update]'
    end 
  end

  service 'sssd' do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
  end


