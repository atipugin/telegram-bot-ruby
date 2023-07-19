# frozen_string_literal: true

RSpec.describe Telegram::Bot::Exceptions::ResponseError do
  subject(:error) do
    described_class.new(response)
  rescue StandardError => e
    e
  end

  let(:response) { Telegram::Bot::Api.new('123456:wrongtoken').call('getMe') }

  describe '#error_code' do
    subject { super().error_code }

    it { is_expected.to eq 401 }
  end
end
