# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultLocation < Base
        attribute :type, Types::String.constrained(eql: 'location').default('location')
        attribute :id, Types::String
        attribute :latitude, Types::Float
        attribute :longitude, Types::Float
        attribute :title, Types::String
        attribute? :horizontal_accuracy, Types::Float
        attribute? :live_period, Types::Integer
        attribute? :heading, Types::Integer
        attribute? :proximity_alert_radius, Types::Integer
        attribute? :reply_markup, InlineKeyboardMarkup
        attribute? :input_message_content, InputMessageContent
        attribute? :thumbnail_url, Types::String
        attribute? :thumbnail_width, Types::Integer
        attribute? :thumbnail_height, Types::Integer
      end
    end
  end
end
