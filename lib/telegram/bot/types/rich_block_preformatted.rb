# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichBlockPreformatted < Base
        attribute :type, Types::String.constrained(eql: 'pre').default('pre')
        attribute :text, RichText
        attribute? :language, Types::String
      end
    end
  end
end
