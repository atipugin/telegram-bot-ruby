# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatMemberRestricted < ChatMember
        attribute :status, Types::String
        attribute :user, User
        attribute :is_member, Types::Bool
        attribute :can_change_info, Types::Bool
        attribute :can_invite_users, Types::Bool
        attribute :can_pin_messages, Types::Bool
        attribute :can_manage_topics, Types::Bool
        attribute :can_send_messages, Types::Bool
        attribute :can_send_media_messages, Types::Bool
        attribute :can_send_polls, Types::Bool
        attribute :can_send_other_messages, Types::Bool
        attribute :can_add_web_page_previews, Types::Bool
        attribute :until_date, Types::Integer
      end
    end
  end
end
