# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputProfilePhotoAnimated < Base
        attribute :type, Types::String.constrained(eql: 'animated').default('animated')
        attribute :animation, Types::String
        attribute? :main_frame_timestamp, Types::Float.default(0.0)
      end
    end
  end
end
