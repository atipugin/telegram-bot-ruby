# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class LinkPreviewOptions < Base
        attribute? :is_disabled, Types::Bool
        attribute? :url, Types::String
        attribute? :prefer_small_media, Types::Bool
        attribute? :prefer_large_media, Types::Bool
        attribute? :show_above_text, Types::Bool
      end
    end
  end
end
