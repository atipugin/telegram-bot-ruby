# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatInviteLink < Base
        attribute :invite_link, Types::String
        attribute :creator, User
        attribute :creates_join_request, Types::Bool
        attribute :is_primary, Types::Bool
        attribute :is_revoked, Types::Bool
        attribute? :name, Types::String
        attribute? :expire_date, Types::Integer
        attribute? :member_limit, Types::Integer
        attribute? :pending_join_request_count, Types::Integer
        attribute? :subscription_period, Types::Integer
        attribute? :subscription_price, Types::Integer
      end
    end
  end
end
