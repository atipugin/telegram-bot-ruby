module Telegram
  module Bot
    module Types
      class InputMediaAnimation < Base
        attribute :type, String, default: 'animation'
        attribute :media, String
        attribute :thumb, String
        attribute :caption, String
        attribute :parse_mode, String
        attribute :width, Integer
        attribute :height, Integer
        attribute :duration, Integer
      end
    end
  end
end
