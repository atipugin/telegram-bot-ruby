# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MessageAutoDeleteTimerChanged < Base
        attribute :message_auto_delete_time, Types::Integer
      end
    end
  end
end
