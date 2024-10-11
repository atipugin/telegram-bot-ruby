# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputPaidMediaVideo < Base
        attribute :type, Types::String.default('video')
        attribute :media, Types::String
        attribute? :thumbnail, Types::String
        attribute? :width, Types::Integer
        attribute? :height, Types::Integer
        attribute? :duration, Types::Integer
        attribute? :supports_streaming, Types::Bool
      end
    end
  end
end
