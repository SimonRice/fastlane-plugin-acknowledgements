# coding: utf-8
lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/acknowledgements/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-acknowledgements'
  spec.version       = Fastlane::Acknowledgements::VERSION
  spec.version = "#{spec.version}-alpha-#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS']
  spec.authors       = ["Simon Rice", "Christophe Knage"]
  spec.email         = ["simon@simonrice.com"]

  spec.summary       = %q{Use Fastlane to give credit where it's rightfully due}
  spec.homepage      = "https://github.com/hjanuschka/fastlane-plugin-acknowledgements"
  spec.license       = %q{THE BEER-WARE LICENSE}

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'CFPropertyList'
  spec.add_dependency 'redcarpet'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 1.104.0'
end
