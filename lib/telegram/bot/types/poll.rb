module Telegram
  module Bot
    module Types
      class Poll < Base
        attribute :id, String
        attribute :question, String
        attribute :options, Array[PollOption]
        attribute :is_closed, Boolean
      end
    end
  end
end
