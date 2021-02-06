# frozen_string_literal: true

module SolidusYotpo
  class Base < ApplicationRecord
    self.abstract_class = true

    def self.table_name_prefix
      'solidus_yotpo_'
    end

    def api
      SolidusYotpo::Api::Client.instance
    end
  end
end
