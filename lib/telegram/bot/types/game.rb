# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Game < Base
        attribute :title, Types::String
        attribute :description, Types::String
        attribute :photo, Types::Array.of(PhotoSize)
        attribute? :text, Types::String
        attribute? :text_entities, Types::Array.of(MessageEntity)
        attribute? :animation, Animation
      end
    end
  end
end
