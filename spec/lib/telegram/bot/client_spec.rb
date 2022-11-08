# frozen_string_literal: true

RSpec.describe Telegram::Bot::Client do
  let(:token) { ENV.fetch('BOT_API_TOKEN') }
  let(:environment) { ENV.fetch('BOT_API_ENV', :test) }

  describe '#run' do
    it 'returns hash' do
      Telegram::Bot::Client.run(token, environment: environment) do |bot|
        result = bot.api.getMe
        expect(result).to be_a(Hash)
        expect(result).to have_key('result')
        expect(result).to have_key('ok')
      end
    end
  end
end
