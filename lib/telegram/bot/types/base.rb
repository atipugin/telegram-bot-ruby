module Telegram
  module Bot
    module Types
      class Base
        include Virtus.model

        def compact_attributes
          attributes.dup.delete_if { |_, v| v.nil? }
        end
      end
    end
  end
end
