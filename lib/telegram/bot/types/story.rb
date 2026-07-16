# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Story < Base
        attribute :chat, Chat
        attribute :id, Types::Integer
      end
    end
  end
end
