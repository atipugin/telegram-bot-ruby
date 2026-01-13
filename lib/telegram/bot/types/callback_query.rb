# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class CallbackQuery < Base
        attribute :id, Types::String
        attribute :from, User
        attribute? :message, MaybeInaccessibleMessage
        attribute? :inline_message_id, Types::String
        attribute :chat_instance, Types::String
        attribute? :data, Types::String
        attribute? :game_short_name, Types::String
      end
    end
  end
end
