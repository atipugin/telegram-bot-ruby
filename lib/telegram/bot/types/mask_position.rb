# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MaskPosition < Base
        attribute :point, Types::String
        attribute :x_shift, Types::Float
        attribute :y_shift, Types::Float
        attribute :scale, Types::Float
      end
    end
  end
end
