module Telegram
  module Bot
    module Types
      module Compactable
        def to_compact_hash
          attributes.inject({}) do |acc, (key, value)|
            next acc if value.nil?

            value = value.to_compact_hash if value.respond_to?(:to_compact_hash)

            acc[key] = value
            acc
          end
        end

        def to_json(*args)
          to_compact_hash.select { |_, v| v }.to_json(*args)
        end

        def as_json(*args)
          to_compact_hash.select { |_, v| v }.as_json(*args)
        end
      end
    end
  end
end
