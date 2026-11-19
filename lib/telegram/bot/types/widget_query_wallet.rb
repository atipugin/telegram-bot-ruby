# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WidgetQueryWallet < Base
        attribute :address, Types::String
        attribute :amount, Types::String
        attribute? :public_key, Types::String
        attribute? :state_init, Types::String
      end
    end
  end
end
