# frozen_string_literal: true

module Telegram
  module Bot
    class Api
      ENDPOINTS = %w[
        getUpdates setWebhook deleteWebhook getWebhookInfo getMe sendMessage
        forwardMessage sendPhoto sendAudio sendDocument sendVideo sendVoice
        sendVideoNote sendMediaGroup sendLocation editMessageLiveLocation
        stopMessageLiveLocation sendVenue sendContact sendChatAction
        getUserProfilePhotos getFile kickChatMember unbanChatMember
        restrictChatMember promoteChatMember leaveChat getChat
        getChatAdministrators exportChatInviteLink setChatPhoto deleteChatPhoto
        setChatTitle setChatDescription pinChatMessage unpinChatMessage
        getChatMembersCount getChatMember setChatStickerSet deleteChatStickerSet
        answerCallbackQuery editMessageText editMessageCaption
        editMessageReplyMarkup deleteMessage sendSticker getStickerSet
        uploadStickerFile createNewStickerSet addStickerToSet
        setStickerPositionInSet deleteStickerFromSet answerInlineQuery
        sendInvoice answerShippingQuery answerPreCheckoutQuery
        sendGame setGameScore getGameHighScores setPassportDataErrors
        editMessageMedia sendAnimation sendPoll stopPoll setChatPermissions
        setChatAdministratorCustomTitle sendDice getMyCommands setMyCommands
        deleteMyCommands setStickerSetThumb logOut close copyMessage
        createChatInviteLink editChatInviteLink revokeChatInviteLink
        approveChatJoinRequest declineChatJoinRequest banChatSenderChat
        unbanChatSenderChat answerWebAppQuery setChatMenuButton
        getChatMenuButton setMyDefaultAdministratorRights
        getMyDefaultAdministratorRights
      ].freeze

      attr_reader :token, :url

      def initialize(token, url: 'https://api.telegram.org')
        @token = token
        @url = url
      end

      def method_missing(method_name, *args, &block)
        endpoint = method_name.to_s
        endpoint = camelize(endpoint) if endpoint.include?('_')

        ENDPOINTS.include?(endpoint) ? call(endpoint, *args) : super
      end

      def respond_to_missing?(*args)
        method_name = args[0].to_s
        method_name = camelize(method_name) if method_name.include?('_')

        ENDPOINTS.include?(method_name) || super
      end

      def call(endpoint, raw_params = {})
        params = build_params(raw_params)
        response = conn.post("/bot#{token}/#{endpoint}", params)
        if response.status == 200
          JSON.parse(response.body)
        else
          raise Exceptions::ResponseError.new(response),
                'Telegram API has returned the error.'
        end
      end

      private

      def build_params(params)
        params.transform_values do |value|
          sanitize_value(value)
        end
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

      def conn
        @conn ||= Faraday.new(url: url) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded
          faraday.adapter Telegram::Bot.configuration.adapter
          faraday.options.timeout = Telegram::Bot.configuration.timeout
          faraday.options.open_timeout = Telegram::Bot.configuration.open_timeout
        end
      end
    end
  end
end
