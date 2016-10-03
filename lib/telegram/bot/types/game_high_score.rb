module Telegram
  module Bot
    module Types
      class GameHighScore < Base
        attribute :position, Integer
        attribute :user, User
        attribute :score, Integer
      end
    end
  end
end
