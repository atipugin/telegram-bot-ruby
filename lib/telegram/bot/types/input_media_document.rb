module Telegram
  module Bot
    module Types
      class InputMediaDocument < Base
        attribute :type, String, default: 'document'
        attribute :media, String
        attribute :thumb, String
        attribute :caption, String
        attribute :parse_mode, String
      end
    end
  end
end
