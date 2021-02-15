# frozen_string_literal: true

module SolidusYotpo
  module ProductDecorator
    YOTPO_ENDPOINT = {
      index: 'v1/widget/%{app_key}/products/%{product_id}/reviews.json',
      create: "apps/%{app_key}/products/mass_create",
      update: "apps/%{app_key}/products/mass_update",
    }.freeze

    def self.prepended(base)
      base.class_eval do
        include SolidusYotpo::Model
        has_many :reviews, class_name: 'SolidusYotpo::Review'
      end
    end

    def sync_reviews
      response = yotpo_api.get(YOTPO_ENDPOINT[:index], product_id: master.sku)
      raw_reviews = Array(response.dig('reviews'))

      raw_reviews.each do |raw_review|
        atts = raw_review.slice('score', 'votes_up', 'votes_down', 'content', 'title')
        atts['external_id'] = raw_review['id']
        reviews.find_by(external_id: atts['external_id'])&.update(atts)
      end
    rescue SolidusYotpo::Api::RequestFailed => e
      raise e # for now
    end

    module ClassMethods
      ::Spree::Product.singleton_class.prepend(self)
    end

    ::Spree::Product.prepend(self)
  end
end
