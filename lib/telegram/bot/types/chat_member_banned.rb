# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberBanned < Base
        attribute :status, Types::String.constrained(eql: 'kicked').default('kicked')
        attribute :user, User
        attribute :until_date, Types::Integer
      end
    end
  end
end
