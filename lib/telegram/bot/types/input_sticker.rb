# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputSticker < Base
        attribute :sticker, Types::String
        attribute :format, Types::String
        attribute :emoji_list, Types::Array.of(Types::String)
        attribute? :mask_position, MaskPosition
        attribute? :keywords, Types::Array.of(Types::String)
      end
    end
  end
end
