# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputMediaDocument < Base
        attribute :type, String, default: 'document'
        attribute :media, String
        attribute :thumb, String
        attribute :caption, String
        attribute :parse_mode, String
        attribute :caption_entities, Array[MessageEntity]
        attribute :disable_content_type_detection, Boolean
      end
    end
  end
end
