module Telegram
  module Bot
    module Types
      class Message < Base
        attribute :message_id, Integer
        attribute :from, User
        attribute :date, Integer
        attribute :chat, Chat
        attribute :forward_from, User
        attribute :forward_date, Integer
        attribute :reply_to_message, Message
        attribute :text, String
        attribute :entities, Array[MessageEntity]
        attribute :audio, Audio
        attribute :document, Document
        attribute :photo, Array[PhotoSize]
        attribute :sticker, Sticker
        attribute :video, Video
        attribute :voice, Voice
        attribute :caption, String
        attribute :contact, Contact
        attribute :location, Location
        attribute :venue, Venue
        attribute :new_chat_member, User
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

        alias to_s text
      end
    end
  end
end
