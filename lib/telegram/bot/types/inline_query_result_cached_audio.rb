module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedAudio < Base
        attribute :type, String, default: 'video'
        attribute :id, String
        attribute :audio_file_id, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
