# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputPaidMediaLivePhoto < Base
        attribute :type, Types::String.constrained(eql: 'live_photo').default('live_photo')
        attribute :media, Types::String
        attribute :photo, Types::String
      end
    end
  end
end
