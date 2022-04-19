# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatJoinRequest < Base
        attribute :chat, Chat
        attribute :from, User
        attribute :date, Integer
        attribute :bio, String
        attribute :invite_link, ChatInviteLink
      end
    end
  end
end
