module Telegram
  module Bot
    module Types
      class InputMediaPhoto < Base
        attribute :type, String
        attribute :media, String
        attribute :caption, String
      end
    end
  end
end
