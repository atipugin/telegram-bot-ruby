module Telegram
  module Bot
    class Api
      include HTTMultiParty

      ENDPOINTS = %w(
        getMe sendMessage forwardMessage sendPhoto sendAudio sendDocument
        sendSticker sendVideo sendVoice sendLocation sendChatAction
        getUserProfilePhotos getUpdates setWebhook
      ).freeze
      REPLY_MARKUP_TYPES = [
        Telegram::Bot::Types::ReplyKeyboardMarkup,
        Telegram::Bot::Types::ReplyKeyboardHide,
        Telegram::Bot::Types::ForceReply
      ].freeze
      POOL_SIZE = ENV.fetch('TELEGRAM_BOT_POOL_SIZE', 1).to_i.freeze

      attr_reader :token

      base_uri 'https://api.telegram.org'
      persistent_connection_adapter pool_size: POOL_SIZE

      def initialize(token)
        @token = token
      end

      def method_missing(method_name, *args, &block)
        method_string = method_name.to_s
        method_name = camelize(method_string) if method_string.include?('_')

        ENDPOINTS.include?(method_string) ? call(method_name, *args) : super
      end

      def call(endpoint, raw_params = {})
        params = build_params(raw_params)
        response = self.class.post("/bot#{token}/#{endpoint}", query: params)
        if response.code == 200
          response.to_hash
        else
          fail Exceptions::ResponseError.new(response),
               'Telegram API has returned the error.'
        end
      end

      private

      def build_params(h)
        h.each_with_object({}) do |(key, value), params|
          params[key] = sanitize_value(value)
        end
      end

      def sanitize_value(value)
        jsonify_reply_markup(value)
      end

      def jsonify_reply_markup(value)
        return value unless REPLY_MARKUP_TYPES.include?(value.class)
        value.to_h.to_json
      end

      def camelize(method_name)
        words = method_name.split('_')
        words.drop(1).each { |word| word.capitalize! }
        words.join.to_sym
      end
    end
  end
end
