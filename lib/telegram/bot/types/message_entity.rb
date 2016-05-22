module Telegram
  module Bot
    module Types
      class MessageEntity < Base
        attribute :type, String
        attribute :offset, Integer
        attribute :length, Integer
        attribute :url, String
        attribute :user, User
      end
    end
  end
end
