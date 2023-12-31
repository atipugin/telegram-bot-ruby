# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultVenue < Base
        attribute :type, Types::String.constrained(eql: 'venue').default('venue')
        attribute :id, Types::String
        attribute :latitude, Types::Float
        attribute :longitude, Types::Float
        attribute :title, Types::String
        attribute :address, Types::String
        attribute? :foursquare_id, Types::String
        attribute? :foursquare_type, Types::String
        attribute? :google_place_id, Types::String
        attribute? :google_place_type, Types::String
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
        attribute? :thumbnail_url, Types::String
        attribute? :thumbnail_width, Types::Integer
        attribute? :thumbnail_height, Types::Integer
      end
    end
  end
end
