# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultMpeg4Gif < Base
        attribute :type, Types::String.constrained(eql: 'mpeg4_gif').default('mpeg4_gif')
        attribute :id, Types::String
        attribute :mpeg4_url, Types::String
        attribute? :mpeg4_width, Types::Integer
        attribute? :mpeg4_height, Types::Integer
        attribute? :mpeg4_duration, Types::Integer
        attribute :thumbnail_url, Types::String
        attribute? :thumbnail_mime_type, Types::String.default('image/jpeg')
        attribute? :title, Types::String
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
