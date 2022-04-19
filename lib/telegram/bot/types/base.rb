# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class Base
        include Virtus.model
        include Compactable
        include PatternMatching
      end
    end
  end
end
