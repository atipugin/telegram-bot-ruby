# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class StoryAreaTypeLink < Base
        attribute :type, Types::String.constrained(eql: 'link').default('link')
        attribute :url, Types::String
      end
    end
  end
end
