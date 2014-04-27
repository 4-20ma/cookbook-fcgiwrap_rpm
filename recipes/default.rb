# encoding: utf-8
#
# Cookbook Name:: fcgiwrap.rpm
# Recipe:: default
#
# Author:: Doc Walker (<4-20ma@wvfans.net>)
#
# Copyright 2014, Doc Walker
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

#------------------------------------------------------------ include_recipe[]
include_recipe 'build-essential'
include_recipe 'yum-epel'

#------------------------------------------------------------------- package[]
# packages required to build all rpms
%w(automake git pkgconfig rpm-build).each do |name|
  package name
end # %w(...).each

# packages required specifically for fcgiwrap
node['fcgiwrap']['packages'].each do |name|
  package name
end # node['fcgiwrap']['packages'].each

#---------------------------------------------------------------------- locals
src_filepath = Pathname.new \
  "#{Chef::Config['file_cache_path'] || '/tmp'}/#{node['fcgiwrap']['name']}"
output = "#{node['fcgiwrap']['name']}-#{node['fcgiwrap']['version']}"

#-------------------------------------------------------------- bash[git_pull]
bash 'git_pull' do
  cwd     src_filepath.to_s
  user    'vagrant'
  group   'vagrant'
  code    'git pull'
  only_if { src_filepath.directory? }
end # bash

#------------------- bash[git_clone https://github.com/schnell18/fcgiwrap.git]
bash "git_clone #{node['fcgiwrap']['git_url']}" do
  cwd     src_filepath.dirname.to_s
  user    'vagrant'
  group   'vagrant'
  code    "git clone #{node['fcgiwrap']['git_url']}"
  not_if  { src_filepath.directory? }
end # bash

#----------------------------------------------------------- bash[git_archive]
bash 'git_archive' do
  cwd     src_filepath.to_s
  user    'vagrant'
  group   'vagrant'
  code    "git archive --prefix #{output}/ HEAD > #{output}.tgz"
  not_if  { (src_filepath + (output + '.tgz')).file? }
end # bash

#------------------------------------------ bash[chown /home/vagrant/rpmbuild]
bash 'chown /home/vagrant/rpmbuild' do
  dir_filepath = Pathname.new('/home/vagrant/rpmbuild')
  code    "chown -R vagrant:vagrant #{dir_filepath}"
  only_if { dir_filepath.directory? }
end # bash

#-------------------------------------------------------------- bash[rpmbuild]
bash 'rpmbuild' do
  cwd         src_filepath.to_s
  user        'vagrant'
  group       'vagrant'
  environment 'HOME' => '/home/vagrant'
  code        "rpmbuild -ta #{output}.tgz"
end # bash

# RPM package will be located at:
#   /home/vagrant/rpmbuild/RPMS/x86_64/fcgiwrap-1.1.0-1.el6.x86_64.rpm
# and locally at:
#   .rpmbuild/RPMS/x86_64/fcgiwrap-1.1.0-1.el6.x86_64.rpm
