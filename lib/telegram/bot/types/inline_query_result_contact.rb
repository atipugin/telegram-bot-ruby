# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultContact < Base
        attribute :type, Types::String.constrained(eql: 'contact').default('contact')
        attribute :id, Types::String
        attribute :phone_number, Types::String
        attribute :first_name, Types::String
        attribute? :last_name, Types::String
        attribute? :vcard, Types::String
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
        attribute? :thumbnail_url, Types::String
        attribute? :thumbnail_width, Types::Integer
        attribute? :thumbnail_height, Types::Integer
      end
    end
  end
end
