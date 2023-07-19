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

  describe '#to_s' do
    subject { super().to_s }

    let(:expected_result) do
      <<~STRING.chomp
        Telegram API has returned the error. (ok: false, error_code: 401, description: "Unauthorized")
      STRING
    end

    it { is_expected.to eq expected_result }
  end
end
