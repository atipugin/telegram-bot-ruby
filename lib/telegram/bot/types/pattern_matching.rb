# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      module PatternMatching
        def deconstruct_keys(_keys)
          attributes
        end
      end
    end
  end
end
