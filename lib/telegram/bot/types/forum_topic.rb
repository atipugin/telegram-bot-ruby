# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ForumTopic < Base
        attribute :message_thread_id, Types::Integer
        attribute :name, Types::String
        attribute :icon_color, Types::Integer
        attribute? :icon_custom_emoji_id, Types::String
      end
    end
  end
end
