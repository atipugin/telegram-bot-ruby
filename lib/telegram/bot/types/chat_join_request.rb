# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatJoinRequest < Base
        attribute :chat, Chat
        attribute :from, User
        attribute :user_chat_id, Types::Integer
        attribute :date, Types::Integer
        attribute? :bio, Types::String
        attribute? :invite_link, ChatInviteLink
      end
    end
  end
end
