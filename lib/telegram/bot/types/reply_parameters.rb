# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ReplyParameters < Base
        attribute :message_id, Types::Integer
        attribute? :chat_id, Types::Integer | Types::String
        attribute? :allow_sending_without_reply, Types::Bool
        attribute? :quote, Types::String
        attribute? :quote_parse_mode, Types::String
        attribute? :quote_entities, Types::Array.of(MessageEntity)
        attribute? :quote_position, Types::Integer
      end
    end
  end
end
