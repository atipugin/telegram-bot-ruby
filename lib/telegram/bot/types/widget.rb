# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Widget < Base
        attribute? :id, Types::String
        attribute? :width, Types::Integer
        attribute? :height, Types::Integer
        attribute :html, Types::String
        attribute? :public_data, Types::String
        attribute? :chat_data, Types::String
      end
    end
  end
end
