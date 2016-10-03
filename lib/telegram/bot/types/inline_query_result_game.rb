module Telegram
  module Bot
    module Types
      class InlineQueryResultGame < Base
        attribute :type, String, default: 'game'
        attribute :id, String
        attribute :game_short_name, String
        attribute :reply_markup, InlineKeyboardMarkup
      end
    end
  end
end
