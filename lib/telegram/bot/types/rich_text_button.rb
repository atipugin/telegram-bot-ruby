# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class RichTextButton < Base
        attribute :type, Types::String.constrained(eql: 'button').default('button')
        attribute :button, RichMessageButton
      end
    end
  end
end
