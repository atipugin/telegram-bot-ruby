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
        Telegram::Bot.configure { |config| config.timeout = 0.001 }
      end

      after do
        Telegram::Bot.configure { |config| config.timeout = 30 }
      end

      it 'raises an error' do
        expect { api_call }
          .to raise_error(Faraday::TimeoutError)
      end
    end

    context 'with low open_timeout' do
      before do
        Telegram::Bot.configure { |config| config.open_timeout = 0.001 }
      end

      after do
        Telegram::Bot.configure { |config| config.open_timeout = 30 }
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
end
