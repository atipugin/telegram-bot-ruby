# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextCashtag < Base
        attribute :type, Types::String.constrained(eql: 'cashtag').default('cashtag')
        attribute :text, Types.deferred(:RichText)
        attribute :cashtag, Types::String
      end
    end
  end
end
