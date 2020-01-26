module Telegram
  module Bot
    module Types
      class PollAnswer < Base
        attribute :poll_id, String
        attribute :user, User
        attribute :option_ids, Array[Integer]
      end
    end
  end
end
