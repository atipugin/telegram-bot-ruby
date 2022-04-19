# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class KeyboardButton < Base
        attribute :text, String
        attribute :request_contact, Boolean
        attribute :request_location, Boolean
        attribute :request_poll, KeyboardButtonPollType
        attribute :web_app, WebAppInfo
      end
    end
  end
end
