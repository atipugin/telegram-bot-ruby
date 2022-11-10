# frozen_string_literal: true

RSpec.describe Telegram::Bot::Client do
  subject(:client) { described_class.new(token, environment: environment) }

  let(:token) { ENV.fetch('BOT_API_TOKEN') }
  let(:environment) { ENV.fetch('BOT_API_ENV', :test) }

  describe '#run' do
    it 'returns hash' do
      expect(client.api.getMe).to include('ok', 'result')
    end
  end
end
