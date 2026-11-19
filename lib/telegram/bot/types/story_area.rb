# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StoryArea < Base
        attribute :position, AreaPosition
        attribute :type, StoryAreaType
      end
    end
  end
end
