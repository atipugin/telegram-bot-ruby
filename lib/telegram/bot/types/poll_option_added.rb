# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PollOptionAdded < Base
        attribute? :poll_message, MaybeInaccessibleMessage
        attribute :option_persistent_id, Types::String
        attribute :option_text, Types::String
        attribute? :option_text_entities, Types::Array.of(MessageEntity)
      end
    end
  end
end
