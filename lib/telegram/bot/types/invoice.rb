module Telegram
  module Bot
    module Types
      class Invoice < Base
        attribute :title, String
        attribute :description, String
        attribute :start_parameter, String
        attribute :currency, String
        attribute :total_amount, Integer
      end
    end
  end
end
