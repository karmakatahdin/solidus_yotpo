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

    def yotpo_sync
      response = yotpo_api.get(YOTPO_ENDPOINT[:index], product_id: master.sku)
      sync_yotpo_reviews Array(response.dig('reviews'))
      update_reviews_summary
    rescue SolidusYotpo::Api::RequestFailed => e
      raise e # for now
    end

    def sync_yotpo_reviews(raw_reviews)
      raw_reviews.each do |raw_review|
        update_atts = raw_review.slice('score', 'votes_up', 'votes_down', 'content', 'title')
        review = reviews.find_by(external_id: raw_review['id'])

        next unless review

        if raw_review['deleted']
          review.destroy
        else
          review.update(update_atts)
        end
      end
    end

    def update_reviews_summary
      update(
        average_score: reviews.average(:score),
        star_distribution: reviews.each_with_object(Hash.new { |h, k| h[k] = 0 }) { |review, acc| acc[review.score] += 1 }.values
      )
    end

    module ClassMethods
      ::Spree::Product.singleton_class.prepend(self)
    end

    ::Spree::Product.prepend(self)
  end
end
