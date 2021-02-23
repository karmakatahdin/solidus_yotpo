# frozen_string_literal: true

require 'singleton'
require 'faraday'

module SolidusYotpo
  module Api
    class RequestFailed < StandardError
      def initialize(path, payload, status, response)
        @path = path.to_s
        @payload = payload
        @status = status
        @response = response
      end

      def message
        [
          "Status: #{@status}",
          "Path: #{@path}",
          "request: #{@payload}",
          "response: #{@response}"
        ].join "\n"
      end

      alias to_s message
    end

    class Client
      include Singleton

      API_URL = 'https://api.yotpo.com/'.freeze

      attr_reader :last_response, :last_response_raw

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

      def request(method_type, path, params = nil, payload = nil)
        @last_response_raw = nil
        @last_response = nil

        payload ||= {}
        payload = JSON.generate(payload) if %i[post put].include? method_type.to_s.downcase.to_sym

        path = resolve_request_path(path, params)

        response = connection.send(method_type, path, payload)
        @last_response_raw = response.body
        json_response = JSON.parse(response.body)
        @last_response = json_response

        status = response.status.to_s

        if !status.starts_with?('2') || json_response.key?('error')
          raise RequestFailed.new(path, payload, status, json_response)
        end

        json_response['response']

      rescue JSON::ParserError
        raise "API response was not a valid JSON: #{response.body.inspect}"
      end

      def resolve_request_path(path, params)
        params ||= {}
        params[:app_key] = SolidusYotpo::Auth.api_key
        path.delete_prefix('/') % params
      end
    end
  end
end
