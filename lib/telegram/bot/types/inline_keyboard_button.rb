# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineKeyboardButton < Base
        attribute :text, String
        attribute :url, String
        attribute :callback_data, String
        attribute :web_app, WebAppInfo
        attribute :login_url, LoginUrl
        attribute :switch_inline_query, String
        attribute :switch_inline_query_current_chat, String
        attribute :callback_game, CallbackGame
        attribute :pay, Boolean
      end
    end
  end
end
