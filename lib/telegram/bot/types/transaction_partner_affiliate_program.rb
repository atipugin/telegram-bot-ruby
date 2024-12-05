# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TransactionPartnerAffiliateProgram < Base
        attribute :type, Types::String.constrained(eql: 'affiliate_program').default('affiliate_program')
        attribute? :sponsor_user, User
        attribute :commission_per_mille, Types::Integer
      end
    end
  end
end
