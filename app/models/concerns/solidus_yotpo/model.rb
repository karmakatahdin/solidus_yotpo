# frozen_string_literal: true

module SolidusYotpo
  module Model
    extend ActiveSupport::Concern

    included do
      include SolidusYotpo::Helpers
    end

    def api
      SolidusYotpo::Api::Client.instance
    end
  end
end
