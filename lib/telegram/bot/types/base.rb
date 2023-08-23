# frozen_string_literal: true

require_relative 'compactable'
require_relative 'pattern_matching'

module Telegram
  module Bot
    module Types
      class Base < Dry::Struct
        include Compactable
        include PatternMatching

        transform_keys(&:to_sym)
      end
    end
  end
end
