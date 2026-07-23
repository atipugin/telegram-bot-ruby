# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockVideo < Base
        attribute :type, Types::String.constrained(eql: 'video').default('video')
        attribute :video, InputMediaVideo
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
