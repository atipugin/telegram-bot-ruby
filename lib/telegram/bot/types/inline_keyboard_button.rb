# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineKeyboardButton < Base
        attribute :text, Types::String
        attribute? :url, Types::String
        attribute? :callback_data, Types::String
        attribute? :web_app, WebAppInfo
        attribute? :login_url, LoginUrl
        attribute? :switch_inline_query, Types::String
        attribute? :switch_inline_query_current_chat, Types::String
        attribute? :switch_inline_query_chosen_chat, SwitchInlineQueryChosenChat
        attribute? :copy_text, CopyTextButton
        attribute? :callback_game, CallbackGame
        attribute? :pay, Types::Bool
      end
    end
  end
end
