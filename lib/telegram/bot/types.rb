# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      include Dry.Types()

      ## Resolve circular dependency
      autoload :Chat, "#{__dir__}/types/chat"
      autoload :Message, "#{__dir__}/types/message"
    end
  end
end

require_relative 'types/base'

Dir["#{__dir__}/types/*.rb"].sort.each { |file| require file }
