# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class ExternalReplyInfo < Base
        attribute :origin, MessageOrigin
        attribute? :chat, Chat
        attribute? :message_id, Types::Integer
        attribute? :link_preview_options, LinkPreviewOptions
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
        attribute? :has_media_spoiler, Types::True
        attribute? :contact, Contact
        attribute? :dice, Dice
        attribute? :game, Game
        attribute? :giveaway, Giveaway
        attribute? :giveaway_winners, GiveawayWinners
        attribute? :invoice, Invoice
        attribute? :location, Location
        attribute? :poll, Poll
        attribute? :venue, Venue
      end
    end
  end
end
