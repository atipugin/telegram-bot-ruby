# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockVideo < Base
        attribute :type, Types::String.constrained(eql: 'video').default('video')
        attribute :video, Video
        attribute? :has_spoiler, Types::True
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
