# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockDocument < Base
        attribute :type, Types::String.constrained(eql: 'document').default('document')
        attribute :document, Document
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
