# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WidgetQueryTypeSentTransaction < Base
        attribute :type, Types::String.constrained(eql: 'sent_transaction').default('sent_transaction')
        attribute :wallet, WidgetQueryWallet
        attribute :msg_hash, Types::String
      end
    end
  end
end
