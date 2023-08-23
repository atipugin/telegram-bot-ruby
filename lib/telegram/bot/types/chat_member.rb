# frozen_string_literal: true

require_relative 'chat_member_administrator'
require_relative 'chat_member_banned'
require_relative 'chat_member_left'
require_relative 'chat_member_member'
require_relative 'chat_member_owner'
require_relative 'chat_member_restricted'

module Telegram
  module Bot
    module Types
      ## Just for classes consistency
      # rubocop:disable Naming/ConstantName
      ChatMember = (
        ChatMemberAdministrator |
        ChatMemberBanned |
        ChatMemberLeft |
        ChatMemberMember |
        ChatMemberOwner |
        ChatMemberRestricted
      )
      # rubocop:enable Naming/ConstantName
    end
  end
end
