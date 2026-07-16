# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostPaid < Base
        attribute? :suggested_post_message, Message
        attribute :currency, Types::String
        attribute? :amount, Types::Integer
        attribute? :star_amount, StarAmount
      end
    end
  end
end
