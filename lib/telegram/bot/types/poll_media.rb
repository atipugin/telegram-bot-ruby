# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PollMedia < Base
        attribute? :animation, Animation
        attribute? :audio, Audio
        attribute? :document, Document
        attribute? :link, Link
        attribute? :live_photo, LivePhoto
        attribute? :location, Location
        attribute? :photo, Types::Array.of(PhotoSize)
        attribute? :sticker, Sticker
        attribute? :venue, Venue
        attribute? :video, Video
      end
    end
  end
end
