# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostRefunded < Base
        attribute? :suggested_post_message, Message
        attribute :reason, Types::String
      end
    end
  end
end
