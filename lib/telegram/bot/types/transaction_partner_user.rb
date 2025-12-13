# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TransactionPartnerUser < Base
        attribute :type, Types::String.constrained(eql: 'user').default('user')
        attribute :transaction_type, Types::String
        attribute :user, User
        attribute? :affiliate, AffiliateInfo
        attribute? :invoice_payload, Types::String
        attribute? :subscription_period, Types::Integer
        attribute? :paid_media, Types::Array.of(PaidMedia)
        attribute? :paid_media_payload, Types::String
        attribute? :gift, Gift
        attribute? :premium_subscription_duration, Types::Integer
      end
    end
  end
end
