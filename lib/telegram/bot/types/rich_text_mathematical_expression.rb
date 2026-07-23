# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextMathematicalExpression < Base
        attribute :type, Types::String.constrained(eql: 'mathematical_expression').default('mathematical_expression')
        attribute :expression, Types::String
      end
    end
  end
end
