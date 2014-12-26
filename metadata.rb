# encoding: utf-8
name              'fcgiwrap_rpm'
maintainer        'Doc Walker'
maintainer_email  '4-20ma@wvfans.net'
description       'Creates rpm package for fcgiwrap.'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
license           'Apache 2.0'
version           '2.0.1'

#------------------------------------------------------- cookbook dependencies
depends           'yum-epel', '~> 0.3.6'

#--------------------------------------------------------- supported platforms
# tested
supports          'centos'

# platform_family?('rhel'): not tested, but should work
supports          'amazon'
supports          'oracle'
supports          'redhat'
supports          'scientific'
