module Telegram
  module Bot
    module Types
      class User < Base
        attribute :id, Integer
        attribute :is_bot, Boolean
        attribute :first_name, String
        attribute :last_name, String
        attribute :username, String
        attribute :language_code, String
        attribute :can_join_groups, Boolean
        attribute :can_read_all_group_messages, Boolean
        attribute :supports_inline_queries, Boolean
      end
    end
  end
end
