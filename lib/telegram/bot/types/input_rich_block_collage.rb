# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockCollage < Base
        attribute :type, Types::String.constrained(eql: 'collage').default('collage')
        attribute :blocks, Types::Array.of(Types.deferred(:InputRichBlock))
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
