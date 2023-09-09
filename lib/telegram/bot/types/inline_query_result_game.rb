# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InlineQueryResultGame < Base
        attribute :type, Types::String.constrained(eql: 'game').default('game')
        attribute :id, Types::String
        attribute :game_short_name, Types::String
        attribute? :reply_markup, InlineKeyboardMarkup
      end
    end
  end
end
