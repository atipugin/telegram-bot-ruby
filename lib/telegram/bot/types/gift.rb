# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Gift < Base
        attribute :id, Types::String
        attribute :sticker, Sticker
        attribute :star_count, Types::Integer
        attribute? :upgrade_star_count, Types::Integer
        attribute? :total_count, Types::Integer
        attribute? :remaining_count, Types::Integer
        attribute? :publisher_chat, Chat
      end
    end
  end
end
