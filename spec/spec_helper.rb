# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# Run Coverage report
require 'solidus_dev_support/rspec/coverage'

# Create the dummy app if it's still missing.
dummy_env = "#{__dir__}/dummy/config/environment.rb"
system "bin/rake extension:test_app" unless File.exist? dummy_env
require dummy_env

# change to feature_helper if system tests are added
require 'solidus_dev_support/rspec/rails_helper'
require 'pry-byebug'
require 'awesome_print'

Dir["#{__dir__}/support/**/*.rb"].sort.each { |f| require f }

SolidusDevSupport::TestingSupport::Factories.load_for(SolidusYotpo::Engine)

RSpec.configure do |c|
  c.infer_spec_type_from_file_location!
  c.use_transactional_fixtures = false
  c.expose_dsl_globally = true
  # c.mock_with :rspec
  c.color = true
  c.fail_fast = ENV['FAIL_FAST'] || false

  if Spree.solidus_gem_version < Gem::Version.new('2.11')
    c.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :system
  end
end
