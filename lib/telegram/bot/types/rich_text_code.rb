# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextCode < Base
        attribute :type, Types::String.constrained(eql: 'code').default('code')
        attribute :text, Types.deferred(:RichText)
      end
    end
  end
end
