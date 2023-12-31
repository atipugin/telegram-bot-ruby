# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedAudio < Base
        attribute :type, Types::String.constrained(eql: 'audio').default('audio')
        attribute :id, Types::String
        attribute :audio_file_id, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
      end
    end
  end
end
