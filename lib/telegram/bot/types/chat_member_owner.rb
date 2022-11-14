# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberOwner < ChatMember
        attribute :status, Types::String
        attribute :user, User
        attribute :is_anonymous, Types::Bool
        attribute? :custom_title, Types::String
      end
    end
  end
end
