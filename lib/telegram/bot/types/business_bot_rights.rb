# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class BusinessBotRights < Base
        attribute? :can_reply, Types::True
        attribute? :can_read_messages, Types::True
        attribute? :can_delete_sent_messages, Types::True
        attribute? :can_delete_all_messages, Types::True
        attribute? :can_edit_name, Types::True
        attribute? :can_edit_bio, Types::True
        attribute? :can_edit_profile_photo, Types::True
        attribute? :can_edit_username, Types::True
        attribute? :can_change_gift_settings, Types::True
        attribute? :can_view_gifts_and_stars, Types::True
        attribute? :can_convert_gifts_to_stars, Types::True
        attribute? :can_transfer_and_upgrade_gifts, Types::True
        attribute? :can_transfer_stars, Types::True
        attribute? :can_manage_stories, Types::True
      end
    end
  end
end
