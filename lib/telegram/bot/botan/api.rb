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
          conn.post("/track?#{query_str}", properties.to_json)
        end

        private

        def conn
          @conn ||= Faraday.new(url: 'https://api.botan.io') do |faraday|
            faraday.request :url_encoded
            faraday.adapter Telegram::Bot.configuration.adapter
          end
        end
      end
    end
  end
end
