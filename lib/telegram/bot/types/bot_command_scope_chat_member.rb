# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeChatMember < Base
        attribute :type, Types::String.constrained(eql: 'chat_member').default('chat_member')
        attribute :chat_id, Types::Integer | Types::String
        attribute :user_id, Types::Integer
      end
    end
  end
end
