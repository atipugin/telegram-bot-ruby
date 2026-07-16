# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ForumTopicCreated < Base
        attribute :name, Types::String
        attribute :icon_color, Types::Integer
        attribute? :icon_custom_emoji_id, Types::String
        attribute? :is_name_implicit, Types::True
      end
    end
  end
end
