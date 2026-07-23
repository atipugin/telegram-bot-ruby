# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichMessageMedia < Base
        attribute :id, Types::String.constrained(min_size: 1, max_size: 64)
        attribute :media,
                  InputMediaAnimation | InputMediaAudio | InputMediaPhoto | InputMediaVideo | InputMediaVoiceNote
      end
    end
  end
end
