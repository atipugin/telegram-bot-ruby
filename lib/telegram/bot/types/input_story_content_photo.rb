# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputStoryContentPhoto < Base
        attribute :type, Types::String.constrained(eql: 'photo').default('photo')
        attribute :photo, Types::String
      end
    end
  end
end
