# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Message < Base
        attribute :message_id, Integer
        attribute :from, User
        attribute :sender_chat, Chat
        attribute :date, Integer
        attribute :chat, Chat
        attribute :forward_from, User
        attribute :forward_from_chat, Chat
        attribute :forward_from_message_id, Integer
        attribute :forward_signature, String
        attribute :forward_sender_name, String
        attribute :forward_date, Integer
        attribute :is_automatic_forward, Boolean
        attribute :reply_to_message, Message
        attribute :via_bot, User
        attribute :edit_date, Integer
        attribute :has_protected_content, Boolean
        attribute :media_group_id, String
        attribute :author_signature, String
        attribute :text, String
        attribute :entities, Array[MessageEntity]
        attribute :animation, Animation
        attribute :audio, Audio
        attribute :document, Document
        attribute :photo, Array[PhotoSize]
        attribute :sticker, Sticker
        attribute :video, Video
        attribute :video_note, VideoNote
        attribute :voice, Voice
        attribute :caption, String
        attribute :caption_entities, Array[MessageEntity]
        attribute :contact, Contact
        attribute :dice, Dice
        attribute :game, Game
        attribute :poll, Poll
        attribute :venue, Venue
        attribute :location, Location
        attribute :new_chat_members, Array[User]
        attribute :left_chat_member, User
        attribute :new_chat_title, String
        attribute :new_chat_photo, Array[PhotoSize]
        attribute :delete_chat_photo, Boolean
        attribute :group_chat_created, Boolean
        attribute :supergroup_chat_created, Boolean
        attribute :channel_chat_created, Boolean
        attribute :message_auto_delete_timer_changed, MessageAutoDeleteTimerChanged
        attribute :migrate_to_chat_id, Integer
        attribute :migrate_from_chat_id, Integer
        attribute :pinned_message, Message
        attribute :invoice, Invoice
        attribute :successful_payment, SuccessfulPayment
        attribute :connected_website, String
        attribute :passport_data, PassportData
        attribute :proximity_alert_triggered, ProximityAlertTriggered
        attribute :video_chat_scheduled, VideoChatScheduled
        attribute :video_chat_started, VideoChatStarted
        attribute :video_chat_ended, VideoChatEnded
        attribute :video_chat_participants_invited, VideoChatParticipantsInvited
        attribute :web_app_data, WebAppData
        attribute :reply_markup, InlineKeyboardMarkup

        alias to_s text
      end
    end
  end
end
