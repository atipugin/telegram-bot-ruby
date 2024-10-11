# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      BotCommandScope = (
        BotCommandScopeDefault |
        BotCommandScopeAllPrivateChats |
        BotCommandScopeAllGroupChats |
        BotCommandScopeAllChatAdministrators |
        BotCommandScopeChat |
        BotCommandScopeChatAdministrators |
        BotCommandScopeChatMember
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
