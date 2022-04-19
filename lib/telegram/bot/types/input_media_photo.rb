# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaPhoto < Base
        attribute :type, String, default: 'photo'
        attribute :media, String
        attribute :caption, String
        attribute :parse_mode, String
      end
    end
  end
end
