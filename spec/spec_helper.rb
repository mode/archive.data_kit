require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'rubygems'
require 'bundler/setup'

SimpleCov.start do
  add_filter "/spec"
end

require 'tmpdir'
require 'data_kit'

RSpec.configure do |config|
  def data_path(file)
    File.join(File.dirname(__FILE__), 'fixtures', file)
  end
end