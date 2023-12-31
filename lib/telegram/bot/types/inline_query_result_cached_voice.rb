# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedVoice < Base
        attribute :type, Types::String.constrained(eql: 'voice').default('voice')
        attribute :id, Types::String
        attribute :voice_file_id, Types::String
        attribute :title, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
      end
    end
  end
end
