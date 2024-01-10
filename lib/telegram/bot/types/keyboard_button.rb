# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class KeyboardButton < Base
        attribute :text, Types::String
        attribute? :request_users, KeyboardButtonRequestUsers
        attribute? :request_chat, KeyboardButtonRequestChat
        attribute? :request_contact, Types::Bool
        attribute? :request_location, Types::Bool
        attribute? :request_poll, KeyboardButtonPollType
        attribute? :web_app, WebAppInfo
      end
    end
  end
end
