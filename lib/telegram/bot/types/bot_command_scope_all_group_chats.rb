# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeAllGroupChats < Base
        attribute :type, String, default: 'all_group_chats'
      end
    end
  end
end
