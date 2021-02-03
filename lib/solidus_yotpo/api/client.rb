require 'singleton'
require 'faraday'

module SolidusYotpo
  module Api
    class Error < StandardError; end

    class Client
      include Singleton

      API_URL = 'https://api.yotpo.com/'.freeze

      class RequestFailed < Error
        def initialize(path, params, status, response)
          @path = path.to_s
          @params = params
          @status = status
          @response = response
        end

        def message
          [
            "Status: #{@status}",
            "Path: #{@path}",
            "request: #{@params}",
            "response: #{@response}"
          ].join "\n"
        end
      end

      attr_reader :last_response, :last_response_raw

      def initialize
      end

      %i[get delete post put].each do |http_method|
        define_method http_method do |*args|
          request(http_method, *args)
        end
      end

      private

      def connection
        @conn ||= Faraday.new(
          url: API_URL,
          headers: {'Content-Type' => 'application/json'}
        )
      end

      def request(method_type, path, params = nil)
        @last_response_raw = nil
        @last_response = nil

        params ||= {}
        params = JSON.generate(params) if %i[post put].include? method_type.to_s.downcase.to_sym

        path = path.delete_prefix('/')

        response = connection.send(method_type, path, params)
        @last_response_raw = response.body
        json_response = JSON.parse(response.body)
        @last_response = json_response

        status = response.status.to_s

        if status.starts_with?('4') || json_response.key?('error')
          raise RequestFailed.new(path, params, status, json_response)
        end

        json_response

      rescue JSON::ParserError
        raise "API response was not a valid JSON: #{response.body.inspect}"
      end
    end
  end
end
