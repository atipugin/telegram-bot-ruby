# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockFooter < Base
        attribute :type, Types::String.constrained(eql: 'footer').default('footer')
        attribute :text, RichText
      end
    end
  end
end
