# frozen_string_literal: true

require 'rake'
require 'rubocop/rake_task'

require 'bundler/setup'
Bundler::GemHelper.install_tasks

task default: :spec

require 'rspec/core/rake_task'
Rspec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-performance'
  task.requires << 'rubocop-rspec'
end
