# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BusinessIntro < Base
        attribute? :title, Types::String
        attribute? :message, Types::String
        attribute? :sticker, Sticker
      end
    end
  end
end
