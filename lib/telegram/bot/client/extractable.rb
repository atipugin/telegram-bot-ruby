module Telegram
  module Bot
    class Client
      module Extractable
        private

        def extract_message(update)
          types = %w(
            inline_query
            chosen_inline_result
            callback_query
            edited_message
            message
            channel_post
            edited_channel_post
          )
          types.inject(nil) { |acc, elem| acc || update.public_send(elem) }
        end
      end
    end
  end
end
