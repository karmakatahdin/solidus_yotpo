# frozen_string_literal: true

require_relative 'lib/solidus_yotpo/version'

Gem::Specification.new do |s|
  s.name = 'solidus_yotpo'
  s.version = SolidusYotpo::VERSION
  s.authors = ['Daniel Portales']
  s.email = 'dportalesr@gmail.com'

  s.summary = 'Yotpo extension for Solidus.'
  s.description = 'Yotpo extension for Solidus.'
  s.homepage = 'https://github.com/karmakatahdin/solidus_yotpo#readme'
  s.license = 'BSD-3-Clause'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/karmakatahdin/solidus_yotpo'
  s.metadata['changelog_uri'] = 'https://github.com/karmakatahdin/solidus_yotpo/blob/master/CHANGELOG.md'

  s.required_ruby_version = Gem::Requirement.new('~> 2.5')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  s.files = files.grep_v(%r{^(test|spec|features)/})
  s.test_files = files.grep(%r{^(test|spec|features)/})
  s.bindir = "exe"
  s.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'solidus_core', ['>= 2.0.0', '< 3']
  s.add_dependency 'solidus_support', '~> 0.5'
  s.add_dependency 'faraday', '~> 1.0'

  s.add_development_dependency 'solidus_dev_support', '~> 2.3'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'pry-byebug'
end
