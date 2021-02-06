# frozen_string_literal: true

module SolidusYotpo
  module Helpers
    private

    def store_host
      @store_host ||=  begin
        Spree::Store.default.url.tap do |store_url|
          store_url.replace("https://#{store_url}") unless store_url =~ /^https?/
        end
      end
    end

    def helpers
      ActionController::Base.helpers
    end

    def app_urls
      Rails.application.routes.url_helpers
    end

    def spree_urls
      Spree::Core::Engine.routes.url_helpers
    end

    def plain_text(text)
      helpers.strip_tags(text.to_s).gsub(/\s+/, ' ')
    end
  end
end
