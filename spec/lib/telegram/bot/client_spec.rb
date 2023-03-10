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

  # rubocop:disable RSpec/SubjectStub
  describe '#listen' do
    subject(:listen) { client.listen }

    let(:api) { double }
    let(:response) { { 'ok' => true, 'result' => [] } }

    before do
      allow(client).to receive(:running).and_return(true, true, false)
      allow(client).to receive(:api).and_return(api)
      allow(api).to receive(:getUpdates).and_return(response)
    end

    it 'calls api' do
      listen
      expect(api).to have_received(:getUpdates).exactly(2).times
    end
  end
  # rubocop:enable RSpec/SubjectStub
end
