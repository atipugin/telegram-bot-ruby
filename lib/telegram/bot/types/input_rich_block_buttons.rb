# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockButtons < Base
        attribute :type, Types::String.constrained(eql: 'buttons').default('buttons')
        attribute :buttons, Types::Array.of(RichMessageButton).constrained(min_size: 1, max_size: 8)
        attribute? :align, Types::String
      end
    end
  end
end
