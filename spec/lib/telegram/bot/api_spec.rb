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
end
