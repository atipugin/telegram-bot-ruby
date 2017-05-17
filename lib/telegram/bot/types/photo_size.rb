module Telegram
  module Bot
    module Types
      class PhotoSize < Base
        attribute :file_id, String
        attribute :width, Integer
        attribute :height, Integer
        attribute :file_size, Integer

        def get_file(api)
          response = api.get_file(file_id: file_id)
          return unless response['ok']
          file_path = response['result']['file_path']
          photo_url = "#{api.url}/file/bot#{api.token}/#{file_path}"
          open(photo_url).read
        end
      end
    end
  end
end
