# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SuggestedPostDeclined < Base
        attribute? :suggested_post_message, Message
        attribute? :comment, Types::String
      end
    end
  end
end
