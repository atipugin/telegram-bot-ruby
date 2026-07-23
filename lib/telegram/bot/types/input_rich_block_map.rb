# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class InputRichBlockMap < Base
        attribute :type, Types::String.constrained(eql: 'map').default('map')
        attribute :location, Location
        attribute :zoom, Types::Integer
        attribute :width, Types::Integer
        attribute :height, Types::Integer
        attribute? :caption, RichBlockCaption
      end
    end
  end
end
