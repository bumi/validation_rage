$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bundler/setup'
Bundler.require
require 'minitest/autorun'
require 'minitest/mock'
require "mocha"

require 'validation_rage'
