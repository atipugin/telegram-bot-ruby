module Telegram
  module Bot
    class Configuration
      attr_accessor :adapter, :faraday

      def initialize
        @adapter = Faraday.default_adapter
      end

      def configure_faraday(&block)
        @faraday = block
      end
    end
  end
end
