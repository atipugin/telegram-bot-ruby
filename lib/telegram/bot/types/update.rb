module Telegram
  module Bot
    module Types
      class Update < Base
        attribute :update_id, Integer
        attribute :message, Message
        attribute :edited_message, Message
        attribute :inline_query, InlineQuery
        attribute :chosen_inline_result, ChosenInlineResult
        attribute :callback_query, CallbackQuery
      end
    end
  end
end
