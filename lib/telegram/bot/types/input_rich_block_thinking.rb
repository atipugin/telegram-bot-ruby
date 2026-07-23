# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockThinking < Base
        attribute :type, Types::String.constrained(eql: 'thinking').default('thinking')
        attribute :text, RichText
      end
    end
  end
end
