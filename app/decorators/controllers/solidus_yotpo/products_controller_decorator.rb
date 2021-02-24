# frozen_string_literal: true

module SolidusYotpo
  module ProductsControllerDecorator
    def self.prepended(base)
      base.class_eval do
        helper ::SolidusYotpo::BaseHelper
      end
    end

    ::Spree::ProductsController.prepend self
  end
end
