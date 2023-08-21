# frozen_string_literal: true

module Telegram
  module Bot
    class Api
      attr_reader :token, :url, :environment

      def initialize(token, url: 'https://api.telegram.org', environment: :production)
        @token = token
        @url = url
        @environment = environment.downcase.to_sym
      end

      def connection
        @connection ||= Faraday.new(url: url) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded
          faraday.adapter Telegram::Bot.configuration.adapter
          faraday.options.timeout = Telegram::Bot.configuration.connection_timeout
          faraday.options.open_timeout = Telegram::Bot.configuration.connection_open_timeout
        end
      end

      def method_missing(method_name, *args, &block)
        endpoint = method_name.to_s
        endpoint = camelize(endpoint) if endpoint.include?('_')

        return super unless ENDPOINTS.key?(endpoint)

        result = call(endpoint, *args)

        return result['ok'] unless (result = result['result'])

        ENDPOINTS[endpoint].call(result)
      end

      def respond_to_missing?(*args)
        method_name = args[0].to_s
        method_name = camelize(method_name) if method_name.include?('_')

        ENDPOINTS.key?(method_name) || super
      end

      def call(endpoint, raw_params = {})
        params = build_params(raw_params)
        path = build_path(endpoint)
        response = connection.post(path, params)
        raise Exceptions::ResponseError.new(response: response) unless response.status == 200

        JSON.parse(response.body)
      end

      private

      def build_params(params)
        params.transform_values do |value|
          sanitize_value(value)
        end
      end

      def build_path(endpoint)
        path = "/bot#{token}/"
        path += 'test/' if environment == :test
        path + endpoint
      end

      def sanitize_value(value)
        jsonify_value(value)
      end

      def jsonify_value(value)
        jsonify_value?(value) ? value.to_json : value
      end

      def jsonify_value?(value)
        value.respond_to?(:to_compact_hash) || value.is_a?(Array)
      end

      def camelize(method_name)
        words = method_name.split('_')
        words.drop(1).map(&:capitalize!)
        words.join
      end
    end
  end
end
