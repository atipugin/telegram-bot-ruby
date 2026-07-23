# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextAnchorLink < Base
        attribute :type, Types::String.constrained(eql: 'anchor_link').default('anchor_link')
        attribute :text, Types.deferred(:RichText)
        attribute :anchor_name, Types::String
      end
    end
  end
end
