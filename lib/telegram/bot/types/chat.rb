# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Chat
        include Virtus.model(finalize: false)
        include Compactable
        include PatternMatching

        attribute :id, Integer
        attribute :type, String
        attribute :title, String
        attribute :username, String
        attribute :first_name, String
        attribute :last_name, String
        attribute :photo, ChatPhoto
        attribute :bio, String
        attribute :has_private_forwards, Boolean
        attribute :description, String
        attribute :invite_link, String
        attribute :pinned_message, 'Telegram::Bot::Types::Message'
        attribute :permissions, ChatPermissions
        attribute :slow_mode_delay, Integer
        attribute :message_auto_delete_time, Integer
        attribute :has_protected_content, Boolean
        attribute :sticker_set_name, String
        attribute :can_set_sticker_set, Boolean
        attribute :all_members_are_administrators, Boolean
        attribute :linked_chat_id, Integer
        attribute :location, ChatLocation
      end
    end
  end
end
