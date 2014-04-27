# encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'
require 'pathname'
Dir.glob(File.dirname(__FILE__) + '/**/*.rb', &method(:require))

ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end # config.expect_with

  config.fail_fast = true
end # RSpec
