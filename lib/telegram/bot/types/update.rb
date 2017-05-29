module Telegram
  module Bot
    module Types
      class Update < Base
        attribute :update_id, Integer
        attribute :message, Message
        attribute :edited_message, Message
        attribute :channel_post, Message
        attribute :edited_channel_post, Message
        attribute :inline_query, InlineQuery
        attribute :chosen_inline_result, ChosenInlineResult
        attribute :callback_query, CallbackQuery
        attribute :shipping_query, ShippingQuery
        attribute :pre_checkout_query, PreCheckoutQuery
      end
    end
  end
end
