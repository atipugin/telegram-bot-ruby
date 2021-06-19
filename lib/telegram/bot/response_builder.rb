module Telegram
  module Bot
    class ResponseBuilder < Api
      def initialize
      end

      def call(endpoint, raw_params = {})
        build_params(raw_params.merge(method: endpoint))
      end
    end
  end
end
