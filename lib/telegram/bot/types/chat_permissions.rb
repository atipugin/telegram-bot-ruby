module Telegram
  module Bot
    module Types
      class ChatPermissions < Base
        attribute :can_send_messages, Boolean
        attribute :can_send_media_messages, Boolean
        attribute :can_send_polls, Boolean
        attribute :can_send_other_messages, Boolean
        attribute :can_add_web_page_previews, Boolean
        attribute :can_change_info, Boolean
        attribute :can_invite_users, Boolean
        attribute :can_pin_messages, Boolean
      end
    end
  end
end
