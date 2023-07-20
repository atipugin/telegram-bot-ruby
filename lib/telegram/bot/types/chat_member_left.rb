# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberLeft < Base
        attribute :status, Types::String.constrained(eql: 'left').default('left')
        attribute :user, User
      end
    end
  end
end
