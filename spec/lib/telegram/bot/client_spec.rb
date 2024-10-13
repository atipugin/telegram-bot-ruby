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

  describe '#stop' do
    context 'when bot receives messages' do
      before do
        allow(client.api).to receive(:getUpdates).and_return [Telegram::Bot::Types::Update.new(update_id: 111_111)]

        current_times = 0

        client.listen do |_message|
          current_times += 1
          client.stop if current_times == expected_times
        end
      end

      let(:expected_times) { 3 }

      specify do
        expect(client.api).to have_received(:getUpdates).exactly(expected_times).times
      end
    end

    context 'when bot does not receive any messages' do
      before do
        current_times = 0

        allow(client.api).to receive(:getUpdates) do
          if current_times >= expected_times - 1
            client.stop
            raise Faraday::TimeoutError
          end

          [Telegram::Bot::Types::Update.new(update_id: 111_111)]
        end

        client.listen do |_message|
          current_times += 1
        end
      end

      let(:expected_times) { 3 }

      specify do
        expect(client.api).to have_received(:getUpdates).exactly(expected_times).times
      end
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
