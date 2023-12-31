# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotCommandScopeAllGroupChats < Base
        attribute :type, Types::String.constrained(eql: 'all_group_chats').default('all_group_chats')
      end
    end
  end
end
