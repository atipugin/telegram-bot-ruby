# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextUrl < Base
        attribute :type, Types::String.constrained(eql: 'url').default('url')
        attribute :text, Types.deferred(:RichText)
        attribute :url, Types::String
      end
    end
  end
end
