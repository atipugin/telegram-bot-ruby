# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberUpdated < Base
        attribute :chat, Chat
        attribute :from, User
        attribute :date, Integer
        attribute :old_chat_member, ChatMember
        attribute :new_chat_member, ChatMember
        attribute :invite_link, ChatInviteLink
      end
    end
  end
end
