module Telegram
  module Bot
    module Types
      class ChatInviteLink < Base
        attribute :invite_link, String
        attribute :creator, User
        attribute :is_primary, Boolean
        attribute :is_revoked, Boolean
        attribute :expire_date, Integer
        attribute :member_limit, Integer
      end
    end
  end
end
