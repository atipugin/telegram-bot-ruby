RSpec.describe Telegram::Bot::Util do
  include described_class

  describe '.deep_array_send' do
    it 'calls method for each element of array' do
      expect(deep_array_send(['1', '2', '3'], :to_i)).to eq([1, 2, 3])
    end

    it 'works with deeply nested array' do
      expect(deep_array_send(['1', ['2'], [['3']]], :to_i))
        .to eq([1, [2], [[3]]])
    end
  end
end
