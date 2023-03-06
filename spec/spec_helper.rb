# frozen_string_literal: true

require 'dotenv/load'
require 'pry'
require 'vcr'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
require_relative 'dummy/config/environment'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.ignore_hosts '127.0.0.1', 'localhost'
  config.hook_into :webmock
end
