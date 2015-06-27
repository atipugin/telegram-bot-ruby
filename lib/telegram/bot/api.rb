module Telegram
  module Bot
    class Api
      include HTTParty

      ENDPOINTS = %w(
        getMe sendMessage forwardMessage sendPhoto sendAudio sendDocument
        sendSticker sendVideo sendLocation sendChatAction getUserProfilePhotos
        getUpdates setWebhook
      ).freeze

      attr_reader :token

      base_uri 'https://api.telegram.org'
      persistent_connection_adapter

      def initialize(token)
        @token = token
      end

      def method_missing(method_name, *args, &block)
        ENDPOINTS.include?(method_name.to_s) ? call(method_name, *args) : super
      end

      def call(endpoint, params = {})
        self.class.get("/bot#{token}/#{endpoint}", query: params).to_h
      end
    end
  end
end
