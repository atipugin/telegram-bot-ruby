module Telegram
  module Bot
    class Configuration
      attr_accessor :adapter

      def initialize
        @adapter = Faraday.default_adapter
      end
    end
  end
end
