# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockVoiceNote < Base
        attribute :type, Types::String.constrained(eql: 'voice_note').default('voice_note')
        attribute :voice_note, Voice
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
