# frozen_string_literal: true

require 'openssl'
require 'json'
require 'uri'

module Telegram
  module Bot
    class WebApp
      TG_KEY = 'WebAppData'

      def initialize(token)
        @token = token
      end

      def verify_data_init(data_init)
        decoded_data = URI.decode_www_form(data_init).to_h
        data_check_string = build_data_check_string(decoded_data)

        secret_key = hmac_sha256(TG_KEY, @token)
        hex = hex_encode(hmac_sha256(secret_key, data_check_string))

        return false unless decoded_data['hash'] == hex

        Types::WebAppUser.new(JSON.parse(decoded_data['user'], symbolize_names: true))
      end

      private

      def build_data_check_string(decoded_data)
        decoded_data.filter_map { |key, value| "#{key}=#{value}" unless key == 'hash' }.sort.join("\n")
      end

      def hmac_sha256(key, data)
        OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, data)
      end

      def hex_encode(data)
        data.unpack1('H*')
      end
    end
  end
end
