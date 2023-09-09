# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Sticker < Base
        attribute :file_id, Types::String
        attribute :file_unique_id, Types::String
        attribute :type, Types::String
        attribute :width, Types::Integer
        attribute :height, Types::Integer
        attribute :is_animated, Types::Bool
        attribute :is_video, Types::Bool
        attribute? :thumbnail, PhotoSize
        attribute? :emoji, Types::String
        attribute? :set_name, Types::String
        attribute? :premium_animation, File
        attribute? :mask_position, MaskPosition
        attribute? :custom_emoji_id, Types::String
        attribute? :needs_repainting, Types::True
        attribute? :file_size, Types::Integer
      end
    end
  end
end
