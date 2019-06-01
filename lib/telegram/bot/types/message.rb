module Telegram
  module Bot
    module Types
      class Message < Base
        attribute :message_id, Integer
        attribute :from, User
        attribute :date, Integer
        attribute :chat, Chat
        attribute :forward_from, User
        attribute :forward_from_chat, Chat
        attribute :forward_from_message_id, Integer
        attribute :forward_signature, String
        attribute :forward_sender_name, String
        attribute :forward_date, Integer
        attribute :reply_to_message, Message
        attribute :edit_date, Integer
        attribute :media_group_id, String
        attribute :author_signature, String
        attribute :text, String
        attribute :entities, Array[MessageEntity]
        attribute :caption_entities, Array[MessageEntity]
        attribute :audio, Audio
        attribute :document, Document
        attribute :animation, Animation
        attribute :game, Game
        attribute :photo, Array[PhotoSize]
        attribute :sticker, Sticker
        attribute :video, Video
        attribute :voice, Voice
        attribute :video_note, VideoNote
        attribute :caption, String
        attribute :contact, Contact
        attribute :location, Location
        attribute :venue, Venue
        attribute :poll, Poll
        attribute :new_chat_members, Array[User]
        attribute :left_chat_member, User
        attribute :new_chat_title, String
        attribute :new_chat_photo, Array[PhotoSize]
        attribute :delete_chat_photo, Boolean
        attribute :group_chat_created, Boolean
        attribute :supergroup_chat_created, Boolean
        attribute :channel_chat_created, Boolean
        attribute :migrate_to_chat_id, Integer
        attribute :migrate_from_chat_id, Integer
        attribute :pinned_message, Message
        attribute :invoice, Invoice
        attribute :successful_payment, SuccessfulPayment
        attribute :connected_website, String
        attribute :passport_data, PassportData
        attribute :reply_markup, InlineKeyboardMarkup

        alias to_s text
      end
    end
  end
end
