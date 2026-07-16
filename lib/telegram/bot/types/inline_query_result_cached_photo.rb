# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedPhoto < Base
        attribute :type, Types::String.constrained(eql: 'photo').default('photo')
        attribute :id, Types::String
        attribute :photo_file_id, Types::String
        attribute? :title, Types::String
        attribute? :description, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :show_caption_above_media, Types::Bool
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
      end
    end
  end
end
