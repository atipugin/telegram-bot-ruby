module Telegram
  module Bot
    module Types
      class LabeledPrice < Base
        attribute :label, String
        attribute :amount, Integer
      end
    end
  end
end
