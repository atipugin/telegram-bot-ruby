module Telegram
  module Bot
    module Types
      class InlineKeyboardButton < Base
        attribute :text, String
        attribute :url, String
        attribute :callback_data, String
        attribute :switch_inline_query, String

        def to_h
          super.delete_if { |_, v| v.nil? }
        end
      end
    end
  end
end
