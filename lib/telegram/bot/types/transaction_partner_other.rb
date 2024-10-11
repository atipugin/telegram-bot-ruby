# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TransactionPartnerOther < Base
        attribute :type, Types::String.default('other')
      end
    end
  end
end
