# frozen_string_literal: true

module Telegram
  module Bot
    module Exceptions
      class ResponseError < Base
        attr_reader :response

        def initialize(response:)
          @response = response

          super("Telegram API has returned the error. (#{data.map { |k, v| %(#{k}: #{v.inspect}) }.join(', ')})")
        end

        def error_code
          data[:error_code] || data['error_code']
        end

        def data
          @data ||= begin
            JSON.parse(response.body)
          rescue JSON::ParserError
            { error_code: response.status, uri: response.env.url.to_s }
          end
        end
      end
    end
  end
end
