module Telegram
  module Bot
    module Types
      class MaskPosition < Base
        attribute :point, String
        attribute :x_shift, Float
        attribute :y_shift, Float
        attribute :zoom, Float
      end
    end
  end
end
