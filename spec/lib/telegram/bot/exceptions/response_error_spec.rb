RSpec.describe Telegram::Bot::Exceptions::ResponseError do
  let(:response) { Telegram::Bot::Api.new('123456:wrongtoken').call('getMe') }

  subject do
    begin
      described_class.new(response)
    rescue Exception => error
      error
    end
  end

  it 'has error code' do
    expect(subject).to respond_to(:error_code)
  end
end
