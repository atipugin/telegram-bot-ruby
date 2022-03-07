require 'pry'

RSpec.describe Telegram::Bot::Types::Compactable do
  let(:dummy_class) { Struct.new(:a, :b).include(described_class) }
  let(:dummy_instance) { dummy_class.new(1, nil) }

  before do
    allow(dummy_instance).to receive(:attributes).and_return(
      { a: dummy_instance.a, b: dummy_instance.b }
    )
  end

  describe '.to_compact_hash' do
    it 'compacts hash' do
      expect(dummy_instance.to_compact_hash).to eq({a: 1})
    end
  end

  describe '.to_json' do
    it 'returns json without b key' do
      result = JSON.generate([dummy_instance])
      expect(JSON.parse(result)).to eq([{"a" => 1}])
    end
  end

  context 'when activesupport applied' do
    describe '.as_json' do
      it 'returns json without b key' do
        require "active_support"
        require "active_support/core_ext/object/json"

        result = [dummy_instance].to_json
        expect(JSON.parse(result)).to eq([{"a" => 1}])
      end
    end
  end
end
