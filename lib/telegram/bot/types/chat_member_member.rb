# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberMember < ChatMember
        attribute :status, Types::String
        attribute :user, User
      end
    end
  end
end
