module Telegram
  module Bot
    class Client
      attr_reader :api, :offset

      def self.run(*args, &block)
        new(*args).run(&block)
      end

      def initialize(token)
        @api = Api.new(token)
        @offset = 0
      end

      def run
        yield self
      end

      def listen
        loop do
          response = api.getUpdates(offset: offset)
          next unless response['ok']

          response['result'].each do |data|
            update = Types::Update.new(data)
            @offset = update.update_id.next
            yield update.message
          end
        end
      end
    end
  end
end
