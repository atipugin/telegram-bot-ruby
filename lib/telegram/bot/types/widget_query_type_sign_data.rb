# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class WidgetQueryTypeSignData < Base
        attribute :type, Types::String.constrained(eql: 'sign_data').default('sign_data')
        attribute :wallet, WidgetQueryWallet
        attribute :sign_data, Types::String
      end
    end
  end
end
