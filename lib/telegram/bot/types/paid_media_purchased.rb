# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PaidMediaPurchased < Base
        attribute :from, User
        attribute :paid_media_payload, Types::String
      end
    end
  end
end
