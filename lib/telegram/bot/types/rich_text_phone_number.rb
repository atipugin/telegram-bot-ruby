# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextPhoneNumber < Base
        attribute :type, Types::String.constrained(eql: 'phone_number').default('phone_number')
        attribute :text, Types.deferred(:RichText)
        attribute :phone_number, Types::String
      end
    end
  end
end
