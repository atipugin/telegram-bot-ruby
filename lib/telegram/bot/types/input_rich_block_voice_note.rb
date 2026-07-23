# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockVoiceNote < Base
        attribute :type, Types::String.constrained(eql: 'voice_note').default('voice_note')
        attribute :voice_note, InputMediaVoiceNote
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
