# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatBackground < Base
        attribute :type, BackgroundType
      end
    end
  end
end
