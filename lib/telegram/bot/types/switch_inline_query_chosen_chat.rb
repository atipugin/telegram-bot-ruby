# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SwitchInlineQueryChosenChat < Base
        attribute? :query, Types::String
        attribute? :allow_user_chats, Types::Bool
        attribute? :allow_bot_chats, Types::Bool
        attribute? :allow_group_chats, Types::Bool
        attribute? :allow_channel_chats, Types::Bool
      end
    end
  end
end
