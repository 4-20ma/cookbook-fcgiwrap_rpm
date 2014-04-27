# encoding: utf-8
#
# Cookbook Name:: fcgiwrap
# Attributes:: default
#

default['fcgiwrap'].tap do |fcgiwrap|
  fcgiwrap['packages'] = %w(fcgi-devel)
  fcgiwrap['git_url'] = 'https://github.com/schnell18/fcgiwrap.git'
  fcgiwrap['name'] = 'fcgiwrap'
  fcgiwrap['version'] = '1.1.0'
end # default[].tap
