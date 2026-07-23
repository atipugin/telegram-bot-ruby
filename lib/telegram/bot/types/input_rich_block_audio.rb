# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockAudio < Base
        attribute :type, Types::String.constrained(eql: 'audio').default('audio')
        attribute :audio, InputMediaAudio
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
