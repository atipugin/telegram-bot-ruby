# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      class MenuButtonCommands < Base
        attribute :type, Types::String.constrained(eql: 'commands').default('commands')
      end
    end
  end
end
