module Telegram
  module Bot
    module Types
      class Contact < Base
        attribute :phone_number, String
        attribute :first_name, String
        attribute :last_name, String
        attribute :user_id, Integer
        attribute :vcard, String
      end
    end
  end
end
