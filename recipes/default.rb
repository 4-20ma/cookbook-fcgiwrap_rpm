# encoding: utf-8
#
# Cookbook Name:: fcgiwrap_rpm
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

#---------------------------------------------------------------------- locals
home = Pathname.new('/') + 'home' + 'vagrant'
products = home + 'products'
rpmbuild = home + 'rpmbuild'
rpms = rpmbuild + 'RPMS'
sources = rpmbuild + 'SOURCES'
output = "#{node['fcgiwrap']['name']}-#{node['fcgiwrap']['version']}"
release = '1'
src_filepath = sources + node['fcgiwrap']['name']
rpm_filepath = rpms + 'x86_64' + "#{output}-#{release}.el6.x86_64.rpm"

#------------------------------------------- include_recipe[yum-epel::default]
include_recipe 'yum-epel::default'

#------------------------------------------------------------------- package[]
# packages required to build all rpms
%w(automake git pkgconfig rpm-build).each do |name|
  package name
end # %w(...).each

# development packages required specifically for fcgiwrap
node['fcgiwrap']['devel_packages'].each do |name|
  package "#{name}-devel"
end # node['fcgiwrap']['packages'].each

#-------------------------------------------------------------- bash[pre_tidy]
bash 'pre_tidy' do
  code    "rm -rf #{src_filepath} #{rpmbuild}/*"
  only_if { node['fcgiwrap']['pre_tidy'] }
end # bash

#----------------------------------------------------------------- directory[]
%w(SOURCES).each do |name|
  directory "#{rpmbuild}/#{name}" do
    user      'vagrant'
    group     'vagrant'
    recursive true
  end # directory
end # %w(...).each

#------------------------------------------ bash[chown /home/vagrant/rpmbuild]
bash "chown #{rpmbuild}" do
  code    "chown -R vagrant:vagrant #{rpmbuild}"
  only_if { rpmbuild.directory? }
end # bash

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

#-------------------------------------------------------------- bash[rpmbuild]
bash 'rpmbuild' do
  cwd         src_filepath.to_s
  user        'vagrant'
  group       'vagrant'
  environment 'HOME' => home.to_s
  code        "rpmbuild -ta #{output}.tgz"
end # bash

#--------------------------------------------------- bash[copy_final_products]
bash 'copy_final_products' do
  cwd     rpm_filepath.dirname.to_s
  user    'vagrant'
  group   'vagrant'
  code    "cp -Ru #{rpm_filepath.dirname}/* #{products}"
  only_if { products.directory? }
end # bash

#------------------------------------------------------------- bash[post_tidy]
bash 'post_tidy' do
  code    "rm -rf #{src_filepath} #{rpmbuild}/*"
  only_if { node['fcgiwrap']['post_tidy'] }
end # bash

# RPM package(s) will be located at:
#   home/
#     vagrant/
#       rpmbuild/
#         RPMS/
#           x86_64/
#             fcgiwrap-x.y.z-r.el6.x86_64.rpm
# and locally at:
#   .products/
#     fcgiwrap-x.y.z-r.el6.x86_64.rpm
