# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextEmailAddress < Base
        attribute :type, Types::String.constrained(eql: 'email_address').default('email_address')
        attribute :text, Types.deferred(:RichText)
        attribute :email_address, Types::String
      end
    end
  end
end
