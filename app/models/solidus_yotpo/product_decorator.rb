# frozen_string_literal: true

module SolidusYotpo
  module ProductDecorator
    def self.prepended(base)
      base.class_eval do
        has_many :reviews, class_name: 'SolidusYotpo::Review'
      end
    end

    module ClassMethods
      ::Spree::Product.singleton_class.prepend(self)
    end

    ::Spree::Product.prepend(self)
  end
end
