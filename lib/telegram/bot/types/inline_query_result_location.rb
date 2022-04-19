# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultLocation < Base
        attribute :type, String, default: 'location'
        attribute :id, String
        attribute :latitude, Float
        attribute :longitude, Float
        attribute :title, String
        attribute :horizontal_accuracy, Float
        attribute :live_period, Integer
        attribute :heading, Integer
        attribute :proximity_alert_radius, Integer
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
        attribute :thumb_url, String
        attribute :thumb_width, Integer
        attribute :thumb_height, Integer
      end
    end
  end
end
