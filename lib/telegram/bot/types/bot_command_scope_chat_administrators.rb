# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeChatAdministrators < Base
        attribute :type, Types::String.constrained(eql: 'chat_administrators').default('chat_administrators')
        attribute :chat_id, Types::Integer | Types::String
      end
    end
  end
end
