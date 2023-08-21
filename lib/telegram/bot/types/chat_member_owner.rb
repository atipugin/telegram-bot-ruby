# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberOwner < Base
        attribute :status, Types::String.constrained(eql: 'creator').default('creator')
        attribute :user, User
        attribute :is_anonymous, Types::Bool
        attribute? :custom_title, Types::String
      end
    end
  end
end
