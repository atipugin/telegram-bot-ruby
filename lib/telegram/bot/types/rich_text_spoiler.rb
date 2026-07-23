# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextSpoiler < Base
        attribute :type, Types::String.constrained(eql: 'spoiler').default('spoiler')
        attribute :text, Types.deferred(:RichText)
      end
    end
  end
end
