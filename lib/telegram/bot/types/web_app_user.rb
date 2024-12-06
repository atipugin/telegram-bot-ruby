# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WebAppUser < Base
        attribute :id, Types::Integer
        attribute :first_name, Types::String
        attribute? :is_bot, Types::Bool
        attribute? :last_name, Types::String
        attribute? :username, Types::String
        attribute? :language_code, Types::String
        attribute? :is_premium, Types::True
        attribute? :added_to_attachment_menu, Types::True
        attribute? :allows_write_to_pm, Types::Bool
        attribute? :photo_url, Types::String
      end
    end
  end
end
