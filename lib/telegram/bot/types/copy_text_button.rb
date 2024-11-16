# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class CopyTextButton < Base
        attribute :text, Types::String.constrained(min_size: 1, max_size: 256)
      end
    end
  end
end
