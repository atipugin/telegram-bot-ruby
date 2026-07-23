# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      include Dry.Types()

      def self.deferred(name)
        Any.constructor do |value, _, &fallback|
          const_get(name, false).call(value, &fallback)
        end
      end
    end
  end
end
