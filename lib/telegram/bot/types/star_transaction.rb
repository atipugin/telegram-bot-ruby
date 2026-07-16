# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StarTransaction < Base
        attribute :id, Types::String
        attribute :amount, Types::Integer
        attribute? :nanostar_amount, Types::Integer
        attribute :date, Types::Integer
        attribute? :source, TransactionPartner
        attribute? :receiver, TransactionPartner
      end
    end
  end
end
