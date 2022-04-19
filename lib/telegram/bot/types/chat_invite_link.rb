# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatInviteLink < Base
        attribute :invite_link, String
        attribute :creator, User
        attribute :creates_join_request, Boolean
        attribute :is_primary, Boolean
        attribute :is_revoked, Boolean
        attribute :name, String
        attribute :expire_date, Integer
        attribute :member_limit, Integer
        attribute :pending_join_request_count, Integer
      end
    end
  end
end
