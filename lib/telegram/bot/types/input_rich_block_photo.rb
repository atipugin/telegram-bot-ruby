# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockPhoto < Base
        attribute :type, Types::String.constrained(eql: 'photo').default('photo')
        attribute :photo, InputMediaPhoto
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
