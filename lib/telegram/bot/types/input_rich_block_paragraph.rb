# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockParagraph < Base
        attribute :type, Types::String.constrained(eql: 'paragraph').default('paragraph')
        attribute :text, RichText
      end
    end
  end
end
