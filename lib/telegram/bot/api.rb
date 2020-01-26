module Telegram
  module Bot
    class Api # rubocop:disable ClassLength
      ENDPOINTS = %w(
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
        setChatAdministratorCustomTitle
      ).freeze
      REPLY_MARKUP_TYPES = [
        Telegram::Bot::Types::ReplyKeyboardMarkup,
        Telegram::Bot::Types::ReplyKeyboardRemove,
        Telegram::Bot::Types::ForceReply,
        Telegram::Bot::Types::InlineKeyboardMarkup
      ].freeze
      INLINE_QUERY_RESULT_TYPES = [
        Telegram::Bot::Types::InlineQueryResultArticle,
        Telegram::Bot::Types::InlineQueryResultPhoto,
        Telegram::Bot::Types::InlineQueryResultGif,
        Telegram::Bot::Types::InlineQueryResultMpeg4Gif,
        Telegram::Bot::Types::InlineQueryResultVideo,
        Telegram::Bot::Types::InlineQueryResultAudio,
        Telegram::Bot::Types::InlineQueryResultVoice,
        Telegram::Bot::Types::InlineQueryResultDocument,
        Telegram::Bot::Types::InlineQueryResultLocation,
        Telegram::Bot::Types::InlineQueryResultVenue,
        Telegram::Bot::Types::InlineQueryResultContact,
        Telegram::Bot::Types::InlineQueryResultGame,
        Telegram::Bot::Types::InlineQueryResultCachedPhoto,
        Telegram::Bot::Types::InlineQueryResultCachedGif,
        Telegram::Bot::Types::InlineQueryResultCachedMpeg4Gif,
        Telegram::Bot::Types::InlineQueryResultCachedSticker,
        Telegram::Bot::Types::InlineQueryResultCachedDocument,
        Telegram::Bot::Types::InlineQueryResultCachedVideo,
        Telegram::Bot::Types::InlineQueryResultCachedVoice,
        Telegram::Bot::Types::InlineQueryResultCachedAudio
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

      def build_params(h)
        h.each_with_object({}) do |(key, value), params|
          params[key] = sanitize_value(value)
        end
      end

      def sanitize_value(value)
        jsonify_inline_query_results(jsonify_reply_markup(value))
      end

      def jsonify_reply_markup(value)
        return value unless REPLY_MARKUP_TYPES.any? { |type| value.is_a?(type) }
        value.to_compact_hash.to_json
      end

      def jsonify_inline_query_results(value)
        return value unless
          value.is_a?(Array) &&
          value.all? { |i| INLINE_QUERY_RESULT_TYPES.any? { |t| i.is_a?(t) } }
        value.map { |i| i.to_compact_hash.select { |_, v| v } }.to_json
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
        end
      end
    end
  end
end
