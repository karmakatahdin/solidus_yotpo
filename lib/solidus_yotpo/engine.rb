# frozen_string_literal: true

require 'spree/core'
require 'solidus_yotpo'

module SolidusYotpo
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_yotpo'

    config.to_prepare do
      ::Spree::Ability.register_ability(::SolidusYotpo::ReviewsAbility)
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
