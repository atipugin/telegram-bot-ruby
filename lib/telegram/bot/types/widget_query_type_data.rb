# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WidgetQueryTypeData < Base
        attribute :type, Types::String.constrained(eql: 'data').default('data')
        attribute? :wallet_card, TonWalletCard
      end
    end
  end
end
