# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultContact < Base
        attribute :type, Types::String.default('contact')
        attribute :id, Types::String
        attribute :phone_number, Types::String
        attribute :first_name, Types::String
        attribute? :last_name, Types::String
        attribute? :vcard, Types::String
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
        attribute? :thumb_url, Types::String
        attribute? :thumb_width, Types::Integer
        attribute? :thumb_height, Types::Integer
      end
    end
  end
end
