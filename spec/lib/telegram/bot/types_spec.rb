# frozen_string_literal: true

require 'json'

file = File.read("#{__dir__}/../../../../data/types.json")
parsed_types = JSON.parse(file)

RSpec.describe Telegram::Bot::Types do
  parsed_types.each do |class_name, attributes|
    describe class_name do
      subject(:klass) { described_class.const_get(class_name, false) }

      # empty / union types have no schema
      next if described_class.const_get(class_name, false).instance_of?(Dry::Struct::Sum)
      next unless described_class.const_get(class_name, false).respond_to?(:schema)

      it 'has correct attributes' do
        expect(klass.schema.keys.map(&:name)).to eq(attributes.keys.map(&:to_sym))
      end
    end
  end

  describe 'live locations' do
    [120, 0x7FFFFFFF].each do |live_period|
      it "accepts a live_period of #{live_period}" do
        content = described_class::InputLocationMessageContent.new(
          latitude: 1.0, longitude: 2.0, live_period: live_period
        )

        expect(content.live_period).to eq(live_period)
      end
    end
  end

  describe '.deferred' do
    let(:deferred_type) { described_class.deferred(:RichText) }
    let(:invalid_value) { { type: 'bold', text: { type: 'unknown' } } }

    it 'coerces a non-recursive union to the correct member type' do
      raw = { type: 'user', date: 1, sender_user: { id: 1, is_bot: false, first_name: 'A' } }
      origin = described_class.deferred(:MessageOrigin)[raw]

      expect(origin).to be_a(described_class::MessageOriginUser)
    end

    it 'raises when the target constant is missing' do
      expect { described_class.deferred(:NotARealUnion)['x'] }
        .to raise_error(NameError, /Telegram::Bot::Types::NotARealUnion/)
    end

    it 'returns false from valid? for invalid input' do
      expect(deferred_type.valid?(invalid_value)).to be(false)
    end

    it 'uses the fallback during safe coercion' do
      expect(deferred_type.call(invalid_value) { :invalid }).to eq(:invalid)
    end

    it 'raises during unsafe coercion' do
      expect { deferred_type[invalid_value] }
        .to raise_error(Dry::Types::CoercionError)
    end
  end

  describe 'recursive rich message coercion' do
    subject(:rich_message) { described_class::RichMessage.new(payload) }

    let(:payload) do
      {
        blocks: [
          {
            type: 'paragraph',
            text: {
              type: 'bold',
              text: {
                type: 'italic',
                text: { type: 'custom_emoji', custom_emoji_id: '5', alternative_text: 'fire' }
              }
            }
          }
        ],
        is_rtl: true
      }
    end

    let(:leaf) { rich_message.blocks.first.text.text.text }

    it 'coerces the top-level block' do
      expect(rich_message.blocks.first).to be_a(described_class::RichBlockParagraph)
    end

    it 'coerces through nested rich-text levels down to the leaf' do
      expect(leaf).to be_a(described_class::RichTextCustomEmoji)
    end

    it 'round-trips through to_h' do
      expect(rich_message.to_h).to eq(payload)
    end
  end

  describe 'RichText plain string and array forms' do
    subject(:message) { described_class::RichMessage.new(payload) }

    let(:payload) { { blocks: [{ type: 'paragraph', text: text }] } }

    context 'with a plain string leaf' do
      let(:text) { 'hello' }

      it { expect(message.blocks.first.text).to eq('hello') }
    end

    context 'with nested bold wrapping a plain string' do
      let(:text) { { type: 'bold', text: 'Hello' } }

      it { expect(message.blocks.first.text).to have_attributes(class: described_class::RichTextBold, text: 'Hello') }
    end

    context 'with an array of mixed rich text segments' do
      let(:text) { ['Hello ', { type: 'bold', text: 'world' }, '!'] }

      it 'coerces segments in place' do
        expect(message.blocks.first.text).to match(
          ['Hello ', an_instance_of(described_class::RichTextBold).and(have_attributes(text: 'world')), '!']
        )
      end
    end

    context 'with string-keyed JSON-like hashes' do
      let(:payload) do
        { 'blocks' => [{ 'type' => 'paragraph', 'text' => { 'type' => 'bold', 'text' => 'Hello from JSON' } }] }
      end

      it { expect { message }.not_to raise_error }
    end
  end
end
