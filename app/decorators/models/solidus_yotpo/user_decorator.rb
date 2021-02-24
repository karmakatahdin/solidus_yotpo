# frozen_string_literal: true

module SolidusYotpo
  module UserDecorator
    def self.prepended(base)
      base.class_eval do
        has_many :reviews, class_name: 'SolidusYotpo::Review'
      end
    end

    module ClassMethods
      Spree.user_class.singleton_class.prepend(self)
    end

    Spree.user_class.prepend(self)
  end
end
