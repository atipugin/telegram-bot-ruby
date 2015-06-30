module Telegram
  module Bot
    module Exceptions
      class ResponseError < Base
        attr_reader :response

        def initialize(response)
          @response = response
        end

        def to_s
          super +
            format(' (%s)', data.map { |k, v| %(#{k}: "#{v}") }.join(', '))
        end

        private

        def data
          @data ||= begin
            JSON.parse(response.body)
          rescue JSON::ParserError
            { error_code: response.code, uri: response.request.last_uri.to_s }
          end
        end
      end
    end
  end
end
