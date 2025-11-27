# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostApprovalFailed < Base
        attribute? :suggested_post_message, Message
        attribute :price, SuggestedPostPrice
      end
    end
  end
end
