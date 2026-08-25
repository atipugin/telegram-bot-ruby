# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockButtons < Base
        attribute :type, Types::String.constrained(eql: 'buttons').default('buttons')
        attribute :buttons, Types::Array.of(RichMessageButton)
        attribute? :align, Types::String
      end
    end
  end
end
