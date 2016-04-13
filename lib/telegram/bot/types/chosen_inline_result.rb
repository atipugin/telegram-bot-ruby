module Telegram
  module Bot
    module Types
      class ChosenInlineResult < Base
        attribute :result_id, String
        attribute :from, User
        attribute :location, Location
        attribute :inline_message_id, String
        attribute :query, String

        alias to_s query
      end
    end
  end
end
