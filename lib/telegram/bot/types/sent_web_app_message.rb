# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class SentWebAppMessage < Base
        attribute? :inline_message_id, Types::String
      end
    end
  end
end
