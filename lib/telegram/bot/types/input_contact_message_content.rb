module Telegram
  module Bot
    module Types
      class InputContactMessageContent < InputMessageContent
        attribute :phone_number, String
        attribute :first_name, String
        attribute :last_name, String
        attribute :vcard, String
      end
    end
  end
end
