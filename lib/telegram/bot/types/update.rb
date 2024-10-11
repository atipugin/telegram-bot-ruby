# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Update < Base
        attribute :update_id, Types::Integer
        attribute? :message, Message
        attribute? :edited_message, Message
        attribute? :channel_post, Message
        attribute? :edited_channel_post, Message
        attribute? :business_connection, BusinessConnection
        attribute? :business_message, Message
        attribute? :edited_business_message, Message
        attribute? :deleted_business_messages, BusinessMessagesDeleted
        attribute? :message_reaction, MessageReactionUpdated
        attribute? :message_reaction_count, MessageReactionCountUpdated
        attribute? :inline_query, InlineQuery
        attribute? :chosen_inline_result, ChosenInlineResult
        attribute? :callback_query, CallbackQuery
        attribute? :shipping_query, ShippingQuery
        attribute? :pre_checkout_query, PreCheckoutQuery
        attribute? :purchased_paid_media, PaidMediaPurchased
        attribute? :poll, Poll
        attribute? :poll_answer, PollAnswer
        attribute? :my_chat_member, ChatMemberUpdated
        attribute? :chat_member, ChatMemberUpdated
        attribute? :chat_join_request, ChatJoinRequest
        attribute? :chat_boost, ChatBoostUpdated
        attribute? :removed_chat_boost, ChatBoostRemoved

        def current_message
          @current_message ||=
            Hash[*attributes.find { |k, v| k != :update_id && v }].values.first
        end
      end
    end
  end
end
