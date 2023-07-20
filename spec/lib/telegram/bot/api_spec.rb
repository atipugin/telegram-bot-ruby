# frozen_string_literal: true

RSpec.describe Telegram::Bot::Api do
  let(:token) { ENV.fetch('BOT_API_TOKEN') }
  let(:environment) { ENV.fetch('BOT_API_ENV', :test) }
  let(:endpoint) { 'getMe' }
  let(:api) { described_class.new(token, environment: environment) }

  describe '#call' do
    subject(:api_call) { api.call(endpoint) }

    it 'returns hash' do
      expect(api_call).to be_a(Hash)
    end

    it 'has status' do
      expect(api_call).to have_key('ok')
    end

    it 'has result' do
      expect(api_call).to have_key('result')
    end

    context 'when token is invalid' do
      let(:token) { '123456:wrongtoken' }

      it 'raises an error' do
        expect { api_call }
          .to raise_error(Telegram::Bot::Exceptions::ResponseError)
      end
    end

    context 'with low timeout' do
      before do
        Telegram::Bot.configure { |config| config.connection_timeout = 0.001 }
      end

      after do
        Telegram::Bot.configure { |config| config.connection_timeout = 30 }
      end

      it 'raises an error' do
        expect { api_call }
          .to raise_error(Faraday::TimeoutError)
      end
    end

    context 'with low open_timeout' do
      before do
        Telegram::Bot.configure { |config| config.connection_open_timeout = 0.001 }
      end

      after do
        Telegram::Bot.configure { |config| config.connection_open_timeout = 30 }
      end

      it 'raises an error' do
        expect { api_call }
          .to raise_error(Faraday::ConnectionFailed)
      end
    end
  end

  describe '#method_missing' do
    subject { api }

    it 'responds to endpoints' do
      expect(api).to respond_to(endpoint)
    end

    context 'when method name is in snake case' do
      let(:endpoint) { 'get_me' }

      it 'responds to snake-cased endpoints' do
        expect(api).to respond_to(endpoint)
      end
    end
  end

  describe '#getMe' do
    subject { api.getMe }

    it { is_expected.to be_an_instance_of(Telegram::Bot::Types::User) }
  end

  describe '#getMyCommands' do
    subject { api.getMyCommands }

    it { is_expected.to all be_an_instance_of(Telegram::Bot::Types::BotCommand) }
  end

  pending '#getChatMenuButton'

  ## I don't know why `setChatMenuButton` returns `OK` but changes nothing
  ## Code is commented, because `pending` is not enough:
  ## some of these specs are not failing returning the same button as it was

  # describe '#getChatMenuButton' do
  #   subject { api.getChatMenuButton }
  #
  #   context "when it's commands" do
  #     let(:menu_button) { Telegram::Bot::Types::MenuButtonCommands.new }
  #
  #     around do |example|
  #       # api.send(:connection).response :logger, nil, { headers: true, bodies: true }
  #
  #       old_menu_button = api.getChatMenuButton
  #       api.setChatMenuButton(menu_button: menu_button)
  #
  #       example.run
  #
  #       api.setChatMenuButton(menu_button: old_menu_button)
  #     end
  #
  #     it { is_expected.to eq menu_button }
  #   end
  #
  #   context "when it's web app" do
  #     let(:menu_button) do
  #       Telegram::Bot::Types::MenuButtonWebApp.new(
  #         text: 'Open link',
  #         web_app: Telegram::Bot::Types::WebAppInfo.new(url: 'https://example.org/')
  #       )
  #     end
  #
  #     around do |example|
  #       # api.send(:connection).response :logger, nil, { headers: true, bodies: true }
  #
  #       old_menu_button = api.getChatMenuButton
  #       api.setChatMenuButton(menu_button: menu_button)
  #
  #       example.run
  #
  #       api.setChatMenuButton(menu_button: old_menu_button)
  #     end
  #
  #     it { is_expected.to eq menu_button }
  #   end
  # end

  describe '#getUpdates' do
    subject { api.getUpdates }

    describe 'with chat member' do
      let(:stubbed_response) do
        {
          'ok' => true,
          'result' => [
            {
              'update_id' => 111_111,
              'my_chat_member' => {
                'chat' => {
                  'id' => 222_222,
                  'first_name' => 'Alexander',
                  'last_name' => 'Popov',
                  'username' => 'AlexWayfer',
                  'type' => 'private'
                },
                'from' => {
                  'id' => 222_222,
                  'is_bot' => false,
                  'first_name' => 'Alexander',
                  'last_name' => 'Popov',
                  'username' => 'AlexWayfer',
                  'language_code' => 'en',
                  'is_premium' => true
                },
                'date' => 1_689_850_120,
                'old_chat_member' => {
                  'user' => {
                    'id' => 333_333,
                    'is_bot' => true,
                    'first_name' => 'Test Bot',
                    'username' => 'test_bot'
                  },
                  'status' => 'member'
                },
                'new_chat_member' => {
                  'user' => {
                    'id' => 333_333,
                    'is_bot' => true,
                    'first_name' => 'Test Bot',
                    'username' => 'test_bot'
                  },
                  'status' => 'kicked',
                  'until_date' => 0
                }
              }
            }
          ]
        }
      end

      let(:expected_data) do
        [
          Telegram::Bot::Types::Update.new(
            'update_id' => 111_111,
            'my_chat_member' => Telegram::Bot::Types::ChatMemberUpdated.new(
              'chat' => Telegram::Bot::Types::Chat.new(
                'id' => 222_222,
                'first_name' => 'Alexander',
                'last_name' => 'Popov',
                'username' => 'AlexWayfer',
                'type' => 'private'
              ),
              'from' => Telegram::Bot::Types::User.new(
                'id' => 222_222,
                'is_bot' => false,
                'first_name' => 'Alexander',
                'last_name' => 'Popov',
                'username' => 'AlexWayfer',
                'language_code' => 'en',
                'is_premium' => true
              ),
              'date' => 1_689_850_120,
              'old_chat_member' => Telegram::Bot::Types::ChatMemberMember.new(
                'user' => {
                  'id' => 333_333,
                  'is_bot' => true,
                  'first_name' => 'Test Bot',
                  'username' => 'test_bot'
                },
                'status' => 'member'
              ),
              'new_chat_member' => Telegram::Bot::Types::ChatMemberBanned.new(
                'user' => {
                  'id' => 333_333,
                  'is_bot' => true,
                  'first_name' => 'Test Bot',
                  'username' => 'test_bot'
                },
                'status' => 'kicked',
                'until_date' => 0
              )
            )
          )
        ]
      end

      before do
        allow(api).to receive(:call).with('getUpdates').and_return(stubbed_response)
      end

      it { is_expected.to eq expected_data }
    end
  end
end
