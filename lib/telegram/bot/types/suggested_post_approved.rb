# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostApproved < Base
        attribute? :suggested_post_message, Message
        attribute? :price, SuggestedPostPrice
        attribute :send_date, Types::Integer
      end
    end
  end
end
