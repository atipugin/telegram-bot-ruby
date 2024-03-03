# frozen_string_literal: true

RSpec.describe Telegram::Bot::WebApp do
  let(:web_app) { described_class.new(token) }
  let(:token) { '6066223859:AAHTBqDfGUUXbb9R0HQmYlrJ6_moCPb6-wI' }

  describe '#verify_data_init' do
    subject { web_app.verify_data_init(data_init) }

    context 'when data_init is invalid' do
      # rubocop:disable Layout/LineLength
      let(:data_init) do
        'query_id=AAFiJKgRAAAAAGIkqBEsKipR&user=%7B%22id%22%3A296232034%2C%22first_name%22%3A%22%D0%9C%D0%B8%D1%85%D0%B0%D0%B8%D0%BB%22%2C%22last_name%22%3A%22%D0%92%D0%B0%D0%BB%D0%BE%D0%B2%22%2C%22username%22%3A%22valovm%22%2C%22language_code%22%3A%22en%22%2C%22is_premium%22%3Atrue%2C%22allows_write_to_pm%22%3Atrue%7D&auth_date=1708281435&hash=c7813b4aee476fa0c79a08e182b197ed8d97a8010cebc813320ea61b0ced2b66'
      end
      # rubocop:enable Layout/LineLength

      it { is_expected.to be_a(Telegram::Bot::Types::WebAppUser) }
    end

    context 'when data_init is valid' do
      let(:data_init) { 'data_init_not_valid' }

      it { is_expected.to be_falsey }
    end
  end
end
