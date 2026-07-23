# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockAnimation < Base
        attribute :type, Types::String.constrained(eql: 'animation').default('animation')
        attribute :animation, Animation
        attribute? :has_spoiler, Types::True
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
