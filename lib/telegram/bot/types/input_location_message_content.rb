module Telegram
  module Bot
    module Types
      class InputLocationMessageContent < InputMessageContent
        attribute :latitude, Float
        attribute :longitude, Float
      end
    end
  end
end
