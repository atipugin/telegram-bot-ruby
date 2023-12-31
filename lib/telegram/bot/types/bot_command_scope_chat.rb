# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeChat < Base
        attribute :type, Types::String.constrained(eql: 'chat').default('chat')
        attribute :chat_id, Types::Integer | Types::String
      end
    end
  end
end
