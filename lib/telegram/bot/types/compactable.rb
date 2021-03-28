module Telegram
  module Bot
    module Types
      module Compactable
        def to_compact_hash
          Hash[attributes.dup.delete_if { |_, v| v.nil? }.map do |key, value|
            value = recursive_hash_conversion(value)
            [key, value]
          end]
        end

        private

        def recursive_hash_conversion(value)
          if value.class.ancestors.include?(Telegram::Bot::Types::Base)
            value.to_compact_hash
          elsif value.is_a?(Array)
            value.map { |arr_content| recursive_hash_conversion(arr_content) }
          else
            value
          end
        end
      end
    end
  end
end
