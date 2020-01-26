module Telegram
  module Bot
    module Types
      class MessageEntity < Base
        attribute :type, String
        attribute :offset, Integer
        attribute :length, Integer
        attribute :url, String
        attribute :user, User
        attribute :language, String
      end
    end
  end
end
