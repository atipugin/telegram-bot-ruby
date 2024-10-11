# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberMember < Base
        attribute :status, Types::String.constrained(eql: 'member').default('member')
        attribute :user, User
        attribute? :until_date, Types::Integer
      end
    end
  end
end
