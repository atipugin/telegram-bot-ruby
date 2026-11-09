# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextTonAddress < Base
        attribute :type, Types::String.constrained(eql: 'ton_address').default('ton_address')
        attribute :text, Types.deferred(:RichText)
        attribute :address, Types::String
      end
    end
  end
end
