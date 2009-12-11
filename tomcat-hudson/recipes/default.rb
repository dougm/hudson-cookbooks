#
# Cookbook Name:: tomcat-hudson
# Recipe:: default
#
# Copyright 2009, Doug MacEachern
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

node.set[:tomcat6][:java_opts] = "-DHUDSON_HOME=/srv/hudson"

include_recipe "tomcat6"

directory "/srv/hudson" do
  action :create
  mode 0755
  owner "#{node[:tomcat6][:user]}"
  group "#{node[:tomcat6][:user]}"
end

remote_file "hudson.war" do
  path "#{node[:tomcat6][:temp]}/ROOT.war"
  not_if { File.exists?("#{node[:tomcat6][:temp]}/ROOT.war") }
  source "http://hudson-ci.org/latest/hudson.war"
  mode 0755
  owner "#{node[:tomcat6][:user]}"
  group "#{node[:tomcat6][:user]}"
end

tomcat_manager "ROOT.war" do
  admin "#{node[:tomcat6][:manager_user]}"
  password "#{node[:tomcat6][:manager_password]}"
  war "#{node[:tomcat6][:temp]}/ROOT.war"
  path "/"
  with_snmp = node[:tomcat6][:with_snmp]
  action :install
end

