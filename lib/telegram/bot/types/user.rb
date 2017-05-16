module Telegram
  module Bot
    module Types
      class User < Base
        attribute :id, Integer
        attribute :first_name, String
        attribute :last_name, String
        attribute :username, String

        def profile_photos(api, offset = nil, limit = nil)
          response = api.getUserProfilePhotos({:user_id => self.id, :offset => offset, :limit => limit})
          response['result']['photos'] = response['result']['photos'].flatten
          response['ok'] ? Types::UserProfilePhotos.new(response['result']) : nil
        end
      end
    end
  end
end
