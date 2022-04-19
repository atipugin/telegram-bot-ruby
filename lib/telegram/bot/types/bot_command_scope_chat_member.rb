# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeChatMember < Base
        attribute :type, String, default: 'chat_member'
        attribute :chat_id, String
        attribute :user_id, Integer
      end
    end
  end
end
