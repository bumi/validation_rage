$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bundler/setup'
Bundler.require
require 'minitest/autorun'
require 'minitest/mock'
require "mocha"

require 'validation_rage'


class MockModel
  def self.after_validation(method)
    @@after_validation_method = method
  end
  def self.after_validation_method
    @@after_validation_method
  end
  def self.name
    "MockClass"
  end
end
