# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultAudio < Base
        attribute :type, Types::String.constrained(eql: 'audio').default('audio')
        attribute :id, Types::String
        attribute :audio_url, Types::String
        attribute :title, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :performer, Types::String
        attribute? :audio_duration, Types::Integer
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
      end
    end
  end
end
