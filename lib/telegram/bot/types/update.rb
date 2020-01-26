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
        attribute :poll, Poll
        attribute :poll_answer, PollAnswer

        def current_message
          @current_message ||=
            Hash[*attributes.find { |k, v| k != :update_id && v }].values.first
        end
      end
    end
  end
end
