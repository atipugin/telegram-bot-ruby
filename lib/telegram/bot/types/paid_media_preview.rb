# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PaidMediaPreview < Base
        attribute :type, Types::String.constrained(eql: 'preview').default('preview')
        attribute? :width, Types::Integer
        attribute? :height, Types::Integer
        attribute? :duration, Types::Integer
      end
    end
  end
end
