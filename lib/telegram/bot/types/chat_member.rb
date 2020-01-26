module Telegram
  module Bot
    module Types
      class ChatMember < Base
        attribute :user, User
        attribute :status, String
        attribute :custom_title, String
        attribute :until_date, Integer
        attribute :can_be_edited, Boolean
        attribute :can_post_messages, Boolean
        attribute :can_edit_messages, Boolean
        attribute :can_delete_messages, Boolean
        attribute :can_restrict_members, Boolean
        attribute :can_promote_members, Boolean
        attribute :can_change_info, Boolean
        attribute :can_invite_users, Boolean
        attribute :can_pin_messages, Boolean
        attribute :is_member, Boolean
        attribute :can_send_messages, Boolean
        attribute :can_send_media_messages, Boolean
        attribute :can_send_polls, Boolean
        attribute :can_send_other_messages, Boolean
        attribute :can_add_web_page_previews, Boolean
      end
    end
  end
end
