# frozen_string_literal: true

RSpec.describe Telegram::Bot::Exceptions::ResponseError, :vcr do
  subject(:error) do
    described_class.new(response)
  rescue StandardError => e
    e
  end

  let(:response) { Telegram::Bot::Api.new('123456:wrongtoken').call('getMe') }

  it 'has error code' do
    expect(error).to respond_to(:error_code)
  end
end
