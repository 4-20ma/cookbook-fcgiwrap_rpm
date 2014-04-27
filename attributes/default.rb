# encoding: utf-8
#
# Cookbook Name:: fcgiwrap.rpm
# Attributes:: default
#

default['fcgiwrap'].tap do |fcgiwrap|
  fcgiwrap['devel_packages'] = %w(fcgi)
  fcgiwrap['git_url'] = 'https://github.com/schnell18/fcgiwrap.git'
  fcgiwrap['name'] = 'fcgiwrap'
  fcgiwrap['version'] = '1.1.0'
  fcgiwrap['pre_tidy'] = false
  fcgiwrap['post_tidy'] = false
end # default[].tap
