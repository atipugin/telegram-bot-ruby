module Telegram
  module Bot
    module Types
      class PollOption < Base
        attribute :text, String
        attribute :voter_count, Integer
      end
    end
  end
end
