# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputStoryContentVideo < Base
        attribute :type, Types::String.constrained(eql: 'video').default('video')
        attribute :video, Types::String
        attribute? :duration, Types::Float
        attribute? :cover_frame_timestamp, Types::Float.default(0.0)
        attribute? :is_animation, Types::Bool
      end
    end
  end
end
