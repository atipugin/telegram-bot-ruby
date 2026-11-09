# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockDocument < Base
        attribute :type, Types::String.constrained(eql: 'document').default('document')
        attribute :document, InputMediaDocument
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
