# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberBanned < ChatMember
        attribute :status, Types::String
        attribute :user, User
        attribute :until_date, Types::Integer
      end
    end
  end
end
