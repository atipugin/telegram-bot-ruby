# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PaidMediaLivePhoto < Base
        attribute :type, Types::String.constrained(eql: 'live_photo').default('live_photo')
        attribute :live_photo, LivePhoto
      end
    end
  end
end
