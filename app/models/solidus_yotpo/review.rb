# frozen_string_literal: true

module SolidusYotpo
  class Review < ApplicationRecord

    include SolidusYotpo::Model

    YOTPO_ENDPOINT = {
      create: 'reviews/dynamic_create',
      show: 'reviews/%{id}',
    }.freeze

    belongs_to :user, class_name: 'Spree::User', counter_cache: true
    belongs_to :product, class_name: 'Spree::Product', counter_cache: true

    validates_presence_of :title, :content, :score, :user, :product
    validates_numericality_of :score, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: SolidusYotpo.config.max_score

    delegate :update_reviews_summary, to: :product

    after_create :send_to_yotpo # TODO: Make async
    after_save :update_reviews_summary

    def send_to_yotpo
      response = yotpo_api.post(YOTPO_ENDPOINT[:create], {}, to_payload)
      yotpo_review_id = response.dig('reviews', 0, 'id')
      update(external_id: yotpo_review_id)
    rescue SolidusYotpo::Api::RequestFailed => e
      raise e
    end

    def product_image_url
      return unless product.gallery.images.first&.attachment_present?

      helpers.image_url(product.gallery.images.first, host: store_host)
    rescue Sprockets::Rails::Helper::AssetNotFound
      # ignore
    end

    def to_payload
      {
        appkey: SolidusYotpo::Auth.api_key,
        sku: product.master.sku,
        product_title: product.name,
        product_description: plain_text(product.description),
        product_url: spree_urls.product_url(product, host: store_host),
        product_image_url: product_image_url,
        display_name: fullname,
        email: user.email,
        review_content: content,
        review_title: title,
        review_score: score,
        time_stamp: created_at.to_i,
        reviewer_type: 'verified_buyer',
        order_metadata: order_payload.compact,
        product_metadata: product_payload.compact,
        customer_metadata: user_payload.compact
      }.compact
    end

    def order
      @order ||= user.orders.joins(line_items: :product).first # || super
    end

    def line_item
      @line_item ||= order.line_items.detect { |li| li.product.id == product.id }
    end

    def fullname
      order.bill_address.slice(:firstname, :lastname).values.join(' ')
    end

    private

    def order_payload
      {
        coupon_used: order.coupon_code.present?.to_s,
        delivery_type: order.shipments.first&.shipping_method&.name,
        custom_properties: [
          { name: 'number', value: order.number },
          { name: 'completed_at', value: order.completed_at.to_s(:iso8601) },
        ]
      }
    end

    def user_payload
      {
        state: order.bill_address.state.to_s,
        country: order.bill_address.country.iso,
        address: order.bill_address.address1,
        phone_number: order.bill_address.phone,
        # custom_properties: [
        #   { name: 'foo', value: 'bar' }
        # ]
      }
    end

    def product_payload
      {
        color: line_item.variant.try(:color),
        size: line_item.variant.try(:size),
        material: product.try(:material),
        model: product.try(:model),
        vendor: (product.try(:store) || Spree::Store.default)&.name,
        # coupon_used: false, # TODO: product coupon detection
        custom_properties: [
          { name: 'variant_sku', value: line_item.sku }
        ]
      }
    end
  end
end
