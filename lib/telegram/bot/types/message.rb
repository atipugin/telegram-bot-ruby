# frozen_string_literal: true

require_relative 'chat_shared'
require_relative 'contact'
require_relative 'dice'
require_relative 'document'
require_relative 'forum_topic_created'
require_relative 'forum_topic_edited'
require_relative 'forum_topic_closed'
require_relative 'forum_topic_reopened'
require_relative 'game'
require_relative 'general_forum_topic_hidden'
require_relative 'general_forum_topic_unhidden'
require_relative 'inline_keyboard_markup'
require_relative 'invoice'
require_relative 'message_auto_delete_timer_changed'
require_relative 'message_entity'
require_relative 'passport_data'
require_relative 'poll'
require_relative 'proximity_alert_triggered'
require_relative 'sticker'
require_relative 'story'
require_relative 'successful_payment'
require_relative 'user_shared'
require_relative 'venue'
require_relative 'video'
require_relative 'video_chat_scheduled'
require_relative 'video_chat_started'
require_relative 'video_chat_ended'
require_relative 'video_chat_participants_invited'
require_relative 'video_note'
require_relative 'voice'
require_relative 'web_app_data'
require_relative 'write_access_allowed'

module Telegram
  module Bot
    module Types
      class Message < Base
        attribute :message_id, Types::Integer
        attribute? :message_thread_id, Types::Integer
        attribute? :from, User
        attribute? :sender_chat, Chat
        attribute :date, Types::Integer
        attribute :chat, Chat
        attribute? :forward_from, User
        attribute? :forward_from_chat, Chat
        attribute? :forward_from_message_id, Types::Integer
        attribute? :forward_signature, Types::String
        attribute? :forward_sender_name, Types::String
        attribute? :forward_date, Types::Integer
        attribute? :is_topic_message, Types::Bool
        attribute? :is_automatic_forward, Types::Bool
        attribute? :reply_to_message, Message
        attribute? :via_bot, User
        attribute? :edit_date, Types::Integer
        attribute? :has_protected_content, Types::Bool
        attribute? :media_group_id, Types::String
        attribute? :author_signature, Types::String
        attribute? :text, Types::String
        attribute? :entities, Types::Array.of(MessageEntity)
        attribute? :animation, Animation
        attribute? :audio, Audio
        attribute? :document, Document
        attribute? :photo, Types::Array.of(PhotoSize)
        attribute? :sticker, Sticker
        attribute? :story, Story
        attribute? :video, Video
        attribute? :video_note, VideoNote
        attribute? :voice, Voice
        attribute? :caption, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :has_media_spoiler, Types::Bool
        attribute? :contact, Contact
        attribute? :dice, Dice
        attribute? :game, Game
        attribute? :poll, Poll
        attribute? :venue, Venue
        attribute? :location, Location
        attribute? :new_chat_members, Types::Array.of(User)
        attribute? :left_chat_member, User
        attribute? :new_chat_title, Types::String
        attribute? :new_chat_photo, Types::Array.of(PhotoSize)
        attribute? :delete_chat_photo, Types::Bool
        attribute? :group_chat_created, Types::Bool
        attribute? :supergroup_chat_created, Types::Bool
        attribute? :channel_chat_created, Types::Bool
        attribute? :message_auto_delete_timer_changed, MessageAutoDeleteTimerChanged
        attribute? :migrate_to_chat_id, Types::Integer
        attribute? :migrate_from_chat_id, Types::Integer
        attribute? :pinned_message, Message
        attribute? :invoice, Invoice
        attribute? :successful_payment, SuccessfulPayment
        attribute? :user_shared, UserShared
        attribute? :chat_shared, ChatShared
        attribute? :connected_website, Types::String
        attribute? :write_access_allowed, WriteAccessAllowed
        attribute? :passport_data, PassportData
        attribute? :proximity_alert_triggered, ProximityAlertTriggered
        attribute? :forum_topic_created, ForumTopicCreated
        attribute? :forum_topic_edited, ForumTopicEdited
        attribute? :forum_topic_closed, ForumTopicClosed
        attribute? :forum_topic_reopened, ForumTopicReopened
        attribute? :general_forum_topic_hidden, GeneralForumTopicHidden
        attribute? :general_forum_topic_unhidden, GeneralForumTopicUnhidden
        attribute? :video_chat_scheduled, VideoChatScheduled
        attribute? :video_chat_started, VideoChatStarted
        attribute? :video_chat_ended, VideoChatEnded
        attribute? :video_chat_participants_invited, VideoChatParticipantsInvited
        attribute? :web_app_data, WebAppData
        attribute? :reply_markup, InlineKeyboardMarkup

        alias to_s text
      end
    end
  end
end
