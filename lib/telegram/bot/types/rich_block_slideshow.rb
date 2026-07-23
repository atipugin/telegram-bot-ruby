# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockSlideshow < Base
        attribute :type, Types::String.constrained(eql: 'slideshow').default('slideshow')
        attribute :blocks, Types::Array.of(Types.deferred(:RichBlock))
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
