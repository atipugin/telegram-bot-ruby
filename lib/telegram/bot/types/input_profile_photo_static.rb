# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputProfilePhotoStatic < Base
        attribute :type, Types::String.constrained(eql: 'static').default('static')
        attribute :photo, Types::String
      end
    end
  end
end
