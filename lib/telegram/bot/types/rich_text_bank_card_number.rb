# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextBankCardNumber < Base
        attribute :type, Types::String.constrained(eql: 'bank_card_number').default('bank_card_number')
        attribute :text, Types.deferred(:RichText)
        attribute :bank_card_number, Types::String
      end
    end
  end
end
