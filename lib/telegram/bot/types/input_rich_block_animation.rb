# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockAnimation < Base
        attribute :type, Types::String.constrained(eql: 'animation').default('animation')
        attribute :animation, InputMediaAnimation
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
