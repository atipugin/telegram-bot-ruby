# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      CHAT_MEMBER = (
        ChatMemberAdministrator |
        ChatMemberBanned |
        ChatMemberLeft |
        ChatMemberMember |
        ChatMemberOwner |
        ChatMemberRestricted
      )
    end
  end
end
