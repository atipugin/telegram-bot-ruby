# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StarTransactions < Base
        attribute :transactions, Types::Array.of(StarTransaction)
      end
    end
  end
end
