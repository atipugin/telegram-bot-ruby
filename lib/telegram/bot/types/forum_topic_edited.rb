# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ForumTopicEdited < Base
        attribute? :name, Types::String
        attribute? :icon_custom_emoji_id, Types::String
      end
    end
  end
end
