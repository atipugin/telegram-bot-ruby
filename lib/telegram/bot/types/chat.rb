# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Chat < Base
        attribute :id, Types::Integer
        attribute :type, Types::String
        attribute? :title, Types::String
        attribute? :username, Types::String
        attribute? :first_name, Types::String
        attribute? :last_name, Types::String
        attribute? :is_forum, Types::Bool
        attribute? :photo, ChatPhoto
        attribute? :active_usernames, Types::Array.of(Types::String)
        attribute? :emoji_status_custom_emoji_id, Types::String
        attribute? :bio, Types::String
        attribute? :has_private_forwards, Types::Bool
        attribute? :has_restricted_voice_and_video_messages, Types::Bool
        attribute? :join_to_send_messages, Types::Bool
        attribute? :join_by_request, Types::Bool
        attribute? :description, Types::String
        attribute? :invite_link, Types::String
        attribute? :pinned_message, Message
        attribute? :permissions, ChatPermissions
        attribute? :slow_mode_delay, Types::Integer
        attribute? :message_auto_delete_time, Types::Integer
        attribute? :has_protected_content, Types::Bool
        attribute? :sticker_set_name, Types::String
        attribute? :can_set_sticker_set, Types::Bool
        attribute? :linked_chat_id, Types::Integer
        attribute? :location, ChatLocation
      end
    end
  end
end
