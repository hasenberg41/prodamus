# frozen_string_literal: true

require File.expand_path('lib/prodamus/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'prodamus'
  spec.version = Prodamus::VERSION
  spec.authors = ['Nikita Kondrashov']
  spec.email = ['hasenberg41@mail.ru']
  spec.summary = 'Prodamus purchases integration for Ruby on Rails'
  spec.description = 'This gem allows to integrate Prodamus purchases service in your Rails app or simple Ruby app.'
  spec.homepage = 'https://github.com/hasenberg41/prodamus'
  spec.license = 'MIT'
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.7.0'

  spec.files = Dir[File.join('lib', '**', '*')]

  spec.extra_rdoc_files = ['README.md']

  spec.add_dependency 'faraday', '~> 2.5'
  spec.add_development_dependency 'dotenv', '~> 2.5'
  spec.add_development_dependency 'pry', '~> 0.14'
  spec.add_development_dependency 'rails', '~> 7.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '~> 1.47'
  spec.add_development_dependency 'rubocop-performance', '~> 1.16'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.19'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.14'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
