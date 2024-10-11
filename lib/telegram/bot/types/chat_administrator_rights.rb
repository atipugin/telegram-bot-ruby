# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatAdministratorRights < Base
        attribute :is_anonymous, Types::Bool
        attribute :can_manage_chat, Types::Bool
        attribute :can_delete_messages, Types::Bool
        attribute :can_manage_video_chats, Types::Bool
        attribute :can_restrict_members, Types::Bool
        attribute :can_promote_members, Types::Bool
        attribute :can_change_info, Types::Bool
        attribute :can_invite_users, Types::Bool
        attribute :can_post_stories, Types::Bool
        attribute :can_edit_stories, Types::Bool
        attribute :can_delete_stories, Types::Bool
        attribute? :can_post_messages, Types::Bool
        attribute? :can_edit_messages, Types::Bool
        attribute? :can_pin_messages, Types::Bool
        attribute? :can_manage_topics, Types::Bool
      end
    end
  end
end
