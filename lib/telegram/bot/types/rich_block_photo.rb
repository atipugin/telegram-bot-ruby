# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockPhoto < Base
        attribute :type, Types::String.constrained(eql: 'photo').default('photo')
        attribute :photo, Types::Array.of(PhotoSize)
        attribute? :has_spoiler, Types::True
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
