# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class TonWalletTransfer < Base
        attribute :transaction_id, Types::String
        attribute :peer_address, Types::String
        attribute :amount, Types::String
        attribute? :comment, Types::String
      end
    end
  end
end
