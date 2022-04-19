# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatAdministratorRight < Base
        attribute :is_anonymous, Boolean
        attribute :can_manage_chat, Boolean
        attribute :can_delete_messages, Boolean
        attribute :can_manage_video_chats, Boolean
        attribute :can_restrict_members, Boolean
        attribute :can_promote_members, Boolean
        attribute :can_change_info, Boolean
        attribute :can_invite_users, Boolean
        attribute :can_post_messages, Boolean
        attribute :can_edit_messages, Boolean
        attribute :can_pin_messages, Boolean
      end
    end
  end
end
