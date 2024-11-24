# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputContactMessageContent < Base
        attribute :phone_number, Types::String
        attribute :first_name, Types::String
        attribute? :last_name, Types::String
        attribute? :vcard, Types::String
      end
    end
  end
end
