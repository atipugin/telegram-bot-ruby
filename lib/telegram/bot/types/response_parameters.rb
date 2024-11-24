# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ResponseParameters < Base
        attribute? :migrate_to_chat_id, Types::Integer
        attribute? :retry_after, Types::Integer
      end
    end
  end
end
