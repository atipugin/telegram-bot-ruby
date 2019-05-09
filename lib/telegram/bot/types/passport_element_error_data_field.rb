module Telegram
  module Bot
    module Types
      class PassportElementErrorDataField < Base
        attribute :source, String, default: 'data'
        attribute :type, String
        attribute :field_name, String
        attribute :data_hash, String
        attribute :message, String
      end
    end
  end
end
