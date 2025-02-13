# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ChatFullInfo < Base
        attribute :id, Types::Integer
        attribute :type, Types::String
        attribute? :title, Types::String
        attribute? :username, Types::String
        attribute? :first_name, Types::String
        attribute? :last_name, Types::String
        attribute? :is_forum, Types::True
        attribute :accent_color_id, Types::Integer
        attribute :max_reaction_count, Types::Integer
        attribute? :photo, ChatPhoto
        attribute? :active_usernames, Types::Array.of(Types::String)
        attribute? :birthdate, Birthdate
        attribute? :business_intro, BusinessIntro
        attribute? :business_location, BusinessLocation
        attribute? :business_opening_hours, BusinessOpeningHours
        attribute? :personal_chat, Chat
        attribute? :available_reactions, Types::Array.of(ReactionType)
        attribute? :background_custom_emoji_id, Types::String
        attribute? :profile_accent_color_id, Types::Integer
        attribute? :profile_background_custom_emoji_id, Types::String
        attribute? :emoji_status_custom_emoji_id, Types::String
        attribute? :emoji_status_expiration_date, Types::Integer
        attribute? :bio, Types::String
        attribute? :has_private_forwards, Types::True
        attribute? :has_restricted_voice_and_video_messages, Types::True
        attribute? :join_to_send_messages, Types::True
        attribute? :join_by_request, Types::True
        attribute? :description, Types::String
        attribute? :invite_link, Types::String
        attribute? :pinned_message, Message
        attribute? :permissions, ChatPermissions
        attribute? :can_send_gift, Types::True
        attribute? :can_send_paid_media, Types::True
        attribute? :slow_mode_delay, Types::Integer
        attribute? :unrestrict_boost_count, Types::Integer
        attribute? :message_auto_delete_time, Types::Integer
        attribute? :has_aggressive_anti_spam_enabled, Types::True
        attribute? :has_hidden_members, Types::True
        attribute? :has_protected_content, Types::True
        attribute? :has_visible_history, Types::True
        attribute? :sticker_set_name, Types::String
        attribute? :can_set_sticker_set, Types::True
        attribute? :custom_emoji_sticker_set_name, Types::String
        attribute? :linked_chat_id, Types::Integer
        attribute? :location, ChatLocation
      end
    end
  end
end
