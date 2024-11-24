# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Message < Base
        attribute :message_id, Types::Integer
        attribute? :message_thread_id, Types::Integer
        attribute? :from, User
        attribute? :sender_chat, Chat
        attribute? :sender_boost_count, Types::Integer
        attribute? :sender_business_bot, User
        attribute :date, Types::Integer
        attribute? :business_connection_id, Types::String
        attribute :chat, Chat
        attribute? :forward_origin, MessageOrigin
        attribute? :is_topic_message, Types::True
        attribute? :is_automatic_forward, Types::True
        attribute? :reply_to_message, Message
        attribute? :external_reply, ExternalReplyInfo
        attribute? :quote, TextQuote
        attribute? :reply_to_story, Story
        attribute? :via_bot, User
        attribute? :edit_date, Types::Integer
        attribute? :has_protected_content, Types::True
        attribute? :is_from_offline, Types::True
        attribute? :media_group_id, Types::String
        attribute? :author_signature, Types::String
        attribute? :text, Types::String
        attribute? :entities, Types::Array.of(MessageEntity)
        attribute? :link_preview_options, LinkPreviewOptions
        attribute? :effect_id, Types::String
        attribute? :animation, Animation
        attribute? :audio, Audio
        attribute? :document, Document
        attribute? :paid_media, PaidMediaInfo
        attribute? :photo, Types::Array.of(PhotoSize)
        attribute? :sticker, Sticker
        attribute? :story, Story
        attribute? :video, Video
        attribute? :video_note, VideoNote
        attribute? :voice, Voice
        attribute? :caption, Types::String
        attribute? :caption_entities, Types::Array.of(MessageEntity)
        attribute? :show_caption_above_media, Types::True
        attribute? :has_media_spoiler, Types::True
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
        attribute? :delete_chat_photo, Types::True
        attribute? :group_chat_created, Types::True
        attribute? :supergroup_chat_created, Types::True
        attribute? :channel_chat_created, Types::True
        attribute? :message_auto_delete_timer_changed, MessageAutoDeleteTimerChanged
        attribute? :migrate_to_chat_id, Types::Integer
        attribute? :migrate_from_chat_id, Types::Integer
        attribute? :pinned_message, MaybeInaccessibleMessage
        attribute? :invoice, Invoice
        attribute? :successful_payment, SuccessfulPayment
        attribute? :refunded_payment, RefundedPayment
        attribute? :users_shared, UsersShared
        attribute? :chat_shared, ChatShared
        attribute? :connected_website, Types::String
        attribute? :write_access_allowed, WriteAccessAllowed
        attribute? :passport_data, PassportData
        attribute? :proximity_alert_triggered, ProximityAlertTriggered
        attribute? :boost_added, ChatBoostAdded
        attribute? :chat_background_set, ChatBackground
        attribute? :forum_topic_created, ForumTopicCreated
        attribute? :forum_topic_edited, ForumTopicEdited
        attribute? :forum_topic_closed, ForumTopicClosed
        attribute? :forum_topic_reopened, ForumTopicReopened
        attribute? :general_forum_topic_hidden, GeneralForumTopicHidden
        attribute? :general_forum_topic_unhidden, GeneralForumTopicUnhidden
        attribute? :giveaway_created, GiveawayCreated
        attribute? :giveaway, Giveaway
        attribute? :giveaway_winners, GiveawayWinners
        attribute? :giveaway_completed, GiveawayCompleted
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
