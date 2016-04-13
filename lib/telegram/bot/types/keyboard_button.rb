module Telegram
  module Bot
    module Types
      class KeyboardButton < Base
        attribute :text, String
        attribute :request_contact, Boolean
        attribute :request_location, Boolean
      end
    end
  end
end
