# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedSticker < Base
        attribute :type, Types::String.constrained(eql: 'sticker').default('sticker')
        attribute :id, Types::String
        attribute :sticker_file_id, Types::String
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
      end
    end
  end
end
