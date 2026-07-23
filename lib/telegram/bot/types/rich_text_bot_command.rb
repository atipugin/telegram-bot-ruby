# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextBotCommand < Base
        attribute :type, Types::String.constrained(eql: 'bot_command').default('bot_command')
        attribute :text, Types.deferred(:RichText)
        attribute :bot_command, Types::String
      end
    end
  end
end
