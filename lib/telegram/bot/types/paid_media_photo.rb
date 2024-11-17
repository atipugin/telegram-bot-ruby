# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PaidMediaPhoto < Base
        attribute :type, Types::String.constrained(eql: 'photo').default('photo')
        attribute :photo, Types::Array.of(PhotoSize)
      end
    end
  end
end
