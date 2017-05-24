module Telegram
  module Bot
    module Types
      class ChatMember < Base
        attribute :user, User
        attribute :status, String
      end
    end
  end
end
