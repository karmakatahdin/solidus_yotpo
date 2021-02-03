require 'singleton'

module SolidusYotpo
  class Auth
    include Singleton

    def initialize
      @api_key = ENV['YOTPO_APP_KEY']
      @secret_key = ENV['YOTPO_SECRET_KEY']
      @client = Api::Client.instance

    end

    def self.method_missing(method_name, *args)
      return instance.send(method_name, *args) if instance.respond_to? method_name

      super
    end

    def token
      Rails.cache.fetch('solidus-yotpo-api-token', expires_in: 1.day) do
        check_env
        resp = @client.post(
          'oauth/token',
          {
            client_id: @api_key,
            client_secret: @secret_key,
            grant_type: 'client_credentials'
          }
        )

        resp['access_token']
      end
    end

    private

    def check_env
      return if [@api_key, @secret_key].all?(&:present?)

      raise Error.new(
        'Configuration error: Make sure both YOTPO_APP_KEY '\
        'and YOTPO_SECRET_KEY environment variables are set.'
      )
    end
  end
end
