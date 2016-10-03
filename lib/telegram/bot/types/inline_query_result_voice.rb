module Telegram
  module Bot
    module Types
      class InlineQueryResultVoice < Base
        attribute :type, String, default: 'voice'
        attribute :id, String
        attribute :voice_url, String
        attribute :title, String
        attribute :caption, String
        attribute :voice_duration, Integer
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
