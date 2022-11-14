# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Contact < Base
        attribute :phone_number, Types::String
        attribute :first_name, Types::String
        attribute? :last_name, Types::String
        attribute? :user_id, Types::Integer
        attribute? :vcard, Types::String
      end
    end
  end
end
