# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'rubocop/vendor/version'

Gem::Specification.new do |s|
  s.name = 'rubocop-vendor'
  s.version = RuboCop::Vendor::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.4'
  s.authors = ['Danilo Cabello', 'Marco Costa', 'Osman Currim']
  s.description = <<-DESCRIPTION
    A collection of RuboCop cops to check for vendor integration
    in Ruby code.
  DESCRIPTION

  s.email = 'foss@wealthsimple.com'
  s.files = `git ls-files config lib LICENSE.txt README.md`.split($RS)
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.homepage = 'https://github.com/wealthsimple/rubocop-vendor'
  s.licenses = ['MIT']
  s.summary = 'Automatic vendor integration checking tool for Ruby code.'

  s.metadata = {
    'homepage_uri' => 'https://rubocop-vendor.readthedocs.io/',
    'changelog_uri' => 'https://github.com/wealthsimple/rubocop-vendor/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/wealthsimple/rubocop-vendor/',
    'documentation_uri' => 'https://rubocop-vendor.readthedocs.io/',
    'bug_tracker_uri' => 'https://github.com/wealthsimple/rubocop-vendor/issues'
  }

  s.add_runtime_dependency('rubocop', '>= 0.53.0')
  s.add_development_dependency('byebug')
  s.add_development_dependency('git')
  s.add_development_dependency('keepachangelog')
  s.add_development_dependency('simplecov')
end
