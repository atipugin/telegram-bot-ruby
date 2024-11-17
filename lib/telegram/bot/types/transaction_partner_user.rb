# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TransactionPartnerUser < Base
        attribute :type, Types::String.constrained(eql: 'user').default('user')
        attribute :user, User
        attribute? :invoice_payload, Types::String
        attribute? :paid_media, Types::Array.of(PaidMedia)
        attribute? :paid_media_payload, Types::String
      end
    end
  end
end
