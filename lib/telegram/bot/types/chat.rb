module Telegram
  module Bot
    module Types
      class Chat < Base
        attribute :id, Integer
        attribute :type, String
        attribute :title, String
        attribute :username, String
        attribute :first_name, String
        attribute :last_name, String
        attribute :all_members_are_administrators, Boolean
      end
    end
  end
end
