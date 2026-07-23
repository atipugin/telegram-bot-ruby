# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichMessage < Base
        attribute? :blocks, Types::Array.of(InputRichBlock)
        attribute? :html, Types::String
        attribute? :markdown, Types::String
        attribute? :media, Types::Array.of(InputRichMessageMedia)
        attribute? :is_rtl, Types::Bool
        attribute? :skip_entity_detection, Types::Bool
      end
    end
  end
end
