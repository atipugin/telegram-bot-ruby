module Telegram
  module Bot
    module Types
      class User < Base
        attribute :id, Integer
        attribute :first_name, String
        attribute :last_name, String
        attribute :username, String

        def profile_photos(api, offset = nil, limit = nil)
          response = api.getUserProfilePhotos(user_id: id,
                                              offset: offset, limit: limit)
          response['result']['photos'].flatten!
          return unless response['ok']
          Types::UserProfilePhotos.new(response['result'])
        end
      end
    end
  end
end
