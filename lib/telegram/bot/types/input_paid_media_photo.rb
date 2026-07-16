# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputPaidMediaPhoto < Base
        attribute :type, Types::String.constrained(eql: 'photo').default('photo')
        attribute :media, Types::String
      end
    end
  end
end
