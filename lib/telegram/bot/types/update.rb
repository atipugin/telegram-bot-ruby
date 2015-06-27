module Telegram
  module Bot
    module Types
      class Update < Base
        attribute :update_id, Integer
        attribute :message, Message
      end
    end
  end
end
