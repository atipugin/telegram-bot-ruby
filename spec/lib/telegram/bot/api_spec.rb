RSpec.describe Telegram::Bot::Api do
  let(:token) { '180956132:AAHU0_CeyQWOd6baBc9TibTPybxY9p1P8xo' }
  let(:endpoint) { 'getMe' }
  let(:api) { described_class.new(token) }

  describe '#call' do
    subject(:api_call) { api.call(endpoint) }

    it 'returns hash' do
      is_expected.to be_a(Hash)
    end

    it 'has status' do
      is_expected.to have_key('ok')
    end

    it 'has result' do
      is_expected.to have_key('result')
    end

    context 'when token is invalid' do
      let(:token) { '123456:wrongtoken' }

      it 'raises an error' do
        expect { api_call }
          .to raise_error(Telegram::Bot::Exceptions::ResponseError)
      end
    end
  end

  describe '#method_missing' do
    subject { api }

    it 'responds to endpoints' do
      is_expected.to respond_to(endpoint)
    end

    context 'when method name is in snake case' do
      let(:endpoint) { 'get_me' }

      it 'responds to snake-cased endpoints' do
        is_expected.to respond_to(endpoint)
      end
    end
  end

  describe '#call' do
    subject(:call) { api.call(endpoint, params) }

    let(:endpoint) { 'api.telegram.local' }

    let(:connection_stub) { instance_spy(Faraday::Connection) }
    let(:response_stub) { instance_double(Faraday::Response) }

    before do
      allow(api).to receive(:conn).and_return(connection_stub)
      allow(connection_stub).to(receive(:post)).and_return(response_stub)
      allow(response_stub).to receive(:status).and_return(200)
      allow(response_stub).to receive(:body).and_return({ ok: true }.to_json)
    end

    context 'when argument is one of REPLY_MARKUP_TYPES' do
      let(:json_arg) { '{"remove_keyboard":true,"selective":false}' }
      let(:params) do
        {
          reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(
            remove_keyboard: true
          )
        }
      end

      it 'converts argument attributes to json' do
        call
        expect(connection_stub).to(
          have_received(:post)
          .with(kind_of(String), reply_markup: json_arg)
        )
      end
    end

    context 'when argument is an array of REPLY_MARKUP_TYPES instances' do
      let(:json_arg) do
        '[{"command":"first","description":"first"},' \
        '{"command":"second","description":"second"}]'
      end

      let(:params) do
        {
          commands: %w(first second).map do |x|
            Telegram::Bot::Types::BotCommand.new(
              command: x.to_s,
              description: x.to_s
            )
          end
        }
      end

      it 'converts each array element to json' do
        call
        expect(connection_stub).to(
          have_received(:post)
          .with(kind_of(String), commands: json_arg)
        )
      end
    end

    context "when argument doesn't belong to REPLY_MARKUP_TYPES" do
      let(:params) { { command: { text: '/start' } } }

      it 'passes argument without converting' do
        call
        expect(connection_stub).to(
          have_received(:post)
          .with(kind_of(String), command: { text: '/start' })
        )
      end
    end
  end
end
