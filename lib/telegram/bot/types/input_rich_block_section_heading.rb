# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockSectionHeading < Base
        attribute :type, Types::String.constrained(eql: 'heading').default('heading')
        attribute :text, RichText
        attribute :size, Types::Integer
      end
    end
  end
end
