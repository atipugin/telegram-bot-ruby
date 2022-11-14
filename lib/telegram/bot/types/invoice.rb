# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Invoice < Base
        attribute :title, Types::String
        attribute :description, Types::String
        attribute :start_parameter, Types::String
        attribute :currency, Types::String
        attribute :total_amount, Types::Integer
      end
    end
  end
end
