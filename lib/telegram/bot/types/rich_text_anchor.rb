# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextAnchor < Base
        attribute :type, Types::String.constrained(eql: 'anchor').default('anchor')
        attribute :name, Types::String
      end
    end
  end
end
