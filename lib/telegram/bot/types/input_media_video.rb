# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaVideo < Base
        attribute :type, String, default: 'video'
        attribute :media, String
        attribute :caption, String
        attribute :parse_mode, String
        attribute :width, Integer
        attribute :height, Integer
        attribute :duration, Integer
        attribute :supports_streaming, Boolean
      end
    end
  end
end
