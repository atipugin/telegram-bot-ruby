module Telegram
  module Bot
    module Types
      class KeyboardButton < Base
        attribute :text, String
        attribute :request_contact, Boolean
        attribute :request_location, Boolean

        def to_h
          super.delete_if { |_, v| v.nil? }
        end
      end
    end
  end
end
