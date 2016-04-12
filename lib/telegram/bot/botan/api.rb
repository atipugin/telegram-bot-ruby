module Telegram
  module Bot
    module Botan
      class Api
        attr_reader :token

        def initialize(token)
          @token = token
        end

        def track(event, uid, properties = {})
          query_str = URI.encode_www_form(token: token, name: event, uid: uid)
          http.post("/track?#{query_str}", URI.encode_www_form(properties))
        end

        private

        def http
          @http ||= begin
            uri = URI.parse('https://api.botan.io')
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true

            http
          end
        end
      end
    end
  end
end
