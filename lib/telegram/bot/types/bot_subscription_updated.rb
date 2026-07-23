# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BotSubscriptionUpdated < Base
        attribute :user, User
        attribute :invoice_payload, Types::String
        attribute :state, Types::String
      end
    end
  end
end
