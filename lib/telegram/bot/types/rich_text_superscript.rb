# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextSuperscript < Base
        attribute :type, Types::String.constrained(eql: 'superscript').default('superscript')
        attribute :text, Types.deferred(:RichText)
      end
    end
  end
end
