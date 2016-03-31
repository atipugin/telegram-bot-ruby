RSpec.describe Telegram::Bot::Api do
  let(:token) { '193705111:AAFqfaTRniQ52LigwhwfzF0Ps3Dv8z-6Kvg' }

  subject { described_class.new(token) }

  describe '#call' do
    let(:endpoint) { 'getMe' }

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
end
