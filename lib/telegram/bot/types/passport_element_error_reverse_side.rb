# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PassportElementErrorReverseSide < Base
        attribute :source, Types::String.constrained(eql: 'reverse_side').default('reverse_side')
        attribute :type, Types::String
        attribute :file_hash, Types::String
        attribute :message, Types::String
      end
    end
  end
end
