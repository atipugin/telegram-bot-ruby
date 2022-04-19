# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      module Compactable
        def to_compact_hash
          attributes.dup.delete_if { |_, v| v.nil? }.map do |key, value|
            value =
              if value.respond_to?(:to_compact_hash)
                value.to_compact_hash
              else
                value
              end

            [key, value]
          end.to_h
        end

        def to_json(*args)
          to_compact_hash.select { |_, v| v }.to_json(*args)
        end
      end
    end
  end
end
