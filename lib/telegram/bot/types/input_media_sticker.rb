# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaSticker < Base
        attribute :type, Types::String.constrained(eql: 'sticker').default('sticker')
        attribute :media, Types::String
        attribute? :emoji, Types::String
      end
    end
  end
end
