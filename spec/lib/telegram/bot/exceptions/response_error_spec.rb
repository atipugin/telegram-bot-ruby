RSpec.describe Telegram::Bot::Exceptions::ResponseError do
  subject do
    begin
      described_class.new(response)
    rescue StandardError => error
      error
    end
  end

  let(:response) { Telegram::Bot::Api.new('123456:wrongtoken').call('getMe') }

  it 'has error code' do
    is_expected.to respond_to(:error_code)
  end
end
