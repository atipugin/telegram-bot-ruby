# frozen_string_literal: true

RSpec.describe Telegram::Bot::Client, :vcr do
  subject(:client) { described_class.new(token, environment: environment) }

  let(:token) { ENV.fetch('BOT_API_TOKEN') }
  let(:environment) { ENV.fetch('BOT_API_ENV', :test) }

  describe '#run' do
    it 'accepts block with itself as an argument' do
      result = nil
      client.run { |something| result = something }

      expect(result).to be client
    end
  end

  describe '#fetch_updates' do
    before do
      allow(client.api).to receive(:call).with('getUpdates', hash_including(offset: 0)).and_return(
        {
          'ok' => true,
          'result' => [
            {
              'update_id' => 222_222,
              'message' => {
                'message_id' => 333_333,
                'from' => {
                  'id' => 111_111,
                  'is_bot' => false,
                  'first_name' => 'Alexander'
                  # "last_name"=>"Popov",
                  # "username"=>"AlexWayfer",
                  # "language_code"=>"en",
                  # "is_premium"=>true
                },
                'chat' => {
                  'id' => 444_444,
                  # 'first_name' => 'Alexander',
                  # "last_name"=>"Popov",
                  # "username"=>"AlexWayfer",
                  'type' => 'private'
                },
                'date' => 1_688_640_799,
                'text' => '/start'
                # "entities" => [{"offset"=>0, "length"=>6, "type"=>"bot_command"}]
              }
            }
          ]
        }
      ).once
    end

    it 'accepts block and pass Message into it' do
      result = nil
      client.fetch_updates { |something| result = something }

      expect(result).to be_a Telegram::Bot::Types::Message
    end
  end
end
