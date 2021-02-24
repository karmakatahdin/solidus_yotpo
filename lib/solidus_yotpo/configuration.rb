# frozen_string_literal: true

module SolidusYotpo
  class Configuration
    # Define here the settings for this extensions, e.g.:
    attr_accessor :max_score, :display_unapproved_reviews, :display_reviewer
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end
