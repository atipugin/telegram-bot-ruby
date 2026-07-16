# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StarAmount < Base
        attribute :amount, Types::Integer
        attribute? :nanostar_amount, Types::Integer
      end
    end
  end
end
