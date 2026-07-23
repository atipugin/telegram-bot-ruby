# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextDateTime < Base
        attribute :type, Types::String.constrained(eql: 'date_time').default('date_time')
        attribute :text, Types.deferred(:RichText)
        attribute :unix_time, Types::Integer
        attribute :date_time_format, Types::String
      end
    end
  end
end
