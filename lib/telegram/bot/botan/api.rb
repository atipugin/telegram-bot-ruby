module Telegram
  module Bot
    module Botan
      class Api
        include HTTParty

        attr_reader :token

        base_uri 'https://api.botan.io'

        def initialize(token)
          @token = token
        end

        def track(event, uid, properties = {})
          self.class.post('/track',
                          query: { token: token, name: event, uid: uid },
                          body: properties.to_json)
        end
      end
    end
  end
end
