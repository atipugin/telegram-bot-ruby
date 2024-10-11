# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PaidMediaVideo < Base
        attribute :type, Types::String.default('video')
        attribute :video, Video
      end
    end
  end
end
