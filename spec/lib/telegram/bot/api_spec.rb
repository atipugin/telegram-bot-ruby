RSpec.describe Telegram::Bot::Api do
  let(:token) { '193705111:AAFqfaTRniQ52LigwhwfzF0Ps3Dv8z-6Kvg' }
  let(:endpoint) { 'getMe' }

  subject { described_class.new(token) }

  describe '#call' do
    it 'returns hash' do
      expect(subject.call(endpoint)).to be_a(Hash)
    end

    it 'has status' do
      expect(subject.call(endpoint)).to have_key('ok')
    end

    it 'has result' do
      expect(subject.call(endpoint)).to have_key('result')
    end

    context 'when token is invalid' do
      let(:token) { '123456:wrongtoken' }

      it 'raises an error' do
        expect { subject.call(endpoint) }
          .to raise_error(Telegram::Bot::Exceptions::ResponseError)
      end
    end
  end

  describe '#method_missing' do
    it 'responds to endpoints' do
      expect(subject).to respond_to(endpoint)
    end

    context 'when method name is in snake case' do
      let(:endpoint) { 'get_me' }

      it 'responds to snake-cased endpoints' do
        expect(subject).to respond_to(endpoint)
      end
    end
  end
end
