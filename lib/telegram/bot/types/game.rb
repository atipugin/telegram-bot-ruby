module Telegram
  module Bot
    module Types
      class Game < Base
        attribute :title, String
        attribute :description, String
        attribute :photo, Array[PhotoSize]
        attribute :text, String
        attribute :text_entities, Array[MessageEntity]
        attribute :animation, Animation
      end
    end
  end
end
