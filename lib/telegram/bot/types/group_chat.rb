module Telegram
  module Bot
    module Types
      class GroupChat < Base
        attribute :id, Integer
        attribute :title, String
      end
    end
  end
end
