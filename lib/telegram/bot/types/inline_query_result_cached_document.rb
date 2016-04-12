module Telegram
  module Bot
    module Types
      class InlineQueryResultCachedDocument < Base
        attribute :type, String, default: 'document'
        attribute :id, String
        attribute :title, String
        attribute :document_file_id, String
        attribute :description, String
        attribute :caption, String
        attribute :reply_markup, InlineKeyboardMarkup
        attribute :input_message_content, InputMessageContent
      end
    end
  end
end
