# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockAudio < Base
        attribute :type, Types::String.constrained(eql: 'audio').default('audio')
        attribute :audio, Audio
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
