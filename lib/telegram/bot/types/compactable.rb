# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      module Compactable
        def to_compact_hash
          attributes.dup.compact.to_h do |key, value|
            value = value.to_compact_hash if value.respond_to?(:to_compact_hash)

            [key, value]
          end
        end

        def to_json(*args)
          to_compact_hash.select { |_, v| v }.to_json(*args)
        end
      end
    end
  end
end
