# frozen_string_literal: true

require 'json'

file = File.read("#{__dir__}/../../../../data/types.json")
parsed_types = JSON.parse(file)

RSpec.describe Telegram::Bot::Types do
  parsed_types.each do |class_name, attributes|
    describe class_name do
      subject(:klass) { described_class.const_get(class_name, false) }

      # empty classes exception
      next if described_class.const_get(class_name, false).instance_of?(Dry::Struct::Sum)

      it 'has correct attributes' do
        expect(klass.schema.keys.map(&:name)).to eq(attributes.keys.map(&:to_sym))
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
      # Error class varies by dry-struct version, so accept either.
      expect { deferred_type[invalid_value] }
        .to raise_error(a_kind_of(Dry::Types::CoercionError).or(a_kind_of(Dry::Struct::Error)))
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
end
