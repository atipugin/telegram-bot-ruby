# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PassportElementErrorFrontSide < Base
        attribute :source, Types::String.constrained(eql: 'front_side').default('front_side')
        attribute :type, Types::String
        attribute :file_hash, Types::String
        attribute :message, Types::String
      end
    end
  end
end
