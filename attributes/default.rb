# encoding: utf-8
#
# Cookbook Name:: fcgiwrap_rpm
# Attributes:: default
#

default['fcgiwrap'].tap do |fcgiwrap|
  fcgiwrap['devel_packages'] = %w(fcgi)
  fcgiwrap['git_url'] = 'https://github.com/schnell18/fcgiwrap.git'
  fcgiwrap['name'] = 'fcgiwrap'
  fcgiwrap['version'] = '1.1.0' # NOTE: may be overridden in .kitchen.yml
  fcgiwrap['pre_tidy'] = false  # NOTE: may be overridden in .kitchen.yml
  fcgiwrap['post_tidy'] = false # NOTE: may be overridden in .kitchen.yml
end # default[].tap
