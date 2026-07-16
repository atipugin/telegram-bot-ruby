# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultVideo < Base
        attribute :type, Types::String.constrained(eql: 'video').default('video')
        attribute :id, Types::String
        attribute :video_url, Types::String
        attribute :mime_type, Types::String
        attribute :thumbnail_url, Types::String
        attribute :title, Types::String
        attribute? :caption, Types::String
        attribute? :parse_mode, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :show_caption_above_media, Types::Bool
        attribute? :video_width, Types::Integer
        attribute? :video_height, Types::Integer
        attribute? :video_duration, Types::Integer
        attribute? :description, Types::String
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
      end
    end
  end
end
