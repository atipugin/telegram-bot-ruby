# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class PassportElementErrorDataField < Base
        attribute :source, Types::String.constrained(eql: 'data').default('data')
        attribute :type, Types::String
        attribute :field_name, Types::String
        attribute :data_hash, Types::String
        attribute :message, Types::String
      end
    end
  end
end
