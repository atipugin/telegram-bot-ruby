# frozen_string_literal: true

require 'nokogiri'
require_relative '../../../rakelib/docs'
require_relative '../../../rakelib/parsers/attribute_parser'

RSpec.describe Parsers::AttributeParser do
  describe '#to_h' do
    subject(:attribute) { described_class.new(row).to_h }

    # A single "Field | Type | Description" row, the way the docs write one.
    let(:row) do
      html = '<table><thead><tr><th>Field</th><th>Type</th><th>Description</th></tr></thead>' \
             "<tbody><tr><td>field</td><td>#{type}</td><td>#{description}</td></tr></tbody></table>"
      Docs::Table.new(Nokogiri::HTML.fragment(html).at('table')).first
    end
    let(:type) { 'String' }
    let(:description) { 'Some text' }

    context 'when not marked Optional' do
      let(:type) { 'Integer' }

      it { is_expected.to eq('type' => 'integer', 'required' => true) }
    end

    context 'when marked Optional' do
      let(:type) { 'Integer' }
      let(:description) { '<em>Optional</em>. Unique identifier' }

      it { is_expected.to eq('type' => 'integer') }
    end

    context 'with a String type' do
      it { is_expected.to include('type' => 'string') }
    end

    context 'with a Float type' do
      let(:type) { 'Float' }

      it { is_expected.to include('type' => 'number') }
    end

    context 'with a linked struct type' do
      let(:type) { '<a href="#User">User</a>' }

      it { is_expected.to include('type' => 'User') }
    end

    context 'with an array type' do
      let(:type) { 'Array of <a href="#PhotoSize">PhotoSize</a>' }

      it { is_expected.to include('type' => 'array') }

      it { is_expected.to include('items' => 'PhotoSize') }
    end

    context 'with a nested array type' do
      let(:type) { 'Array of Array of <a href="#PhotoSize">PhotoSize</a>' }

      it { is_expected.to include('items' => { 'type' => 'array', 'items' => 'PhotoSize' }) }
    end

    context 'with a union of primitives' do
      let(:type) { 'Integer or String' }

      it { is_expected.to include('type' => %w[integer string]) }
    end

    context 'with a quoted discriminator' do
      let(:description) { 'Type of the result, always “article”' }

      it { is_expected.to include('required_value' => 'article') }

      it { is_expected.to include('default' => 'article') }
    end

    context 'with an emphasised discriminator' do
      let(:description) { 'Scope type, must be <em>default</em>' }

      it { is_expected.to include('required_value' => 'default') }

      it { is_expected.to include('default' => 'default') }
    end

    # Regression: a Boolean field reading "... Must be False for callback
    # queries ..." became Bool.constrained(eql: False), which both forbade the
    # True the field exists to carry and emitted a bare Ruby constant.
    context 'with sentence-initial conditional prose' do
      let(:type) { 'Boolean' }
      let(:description) do
        '<em>Optional</em>. Pass <em>True</em> if the ephemeral message must be shown ' \
          'in place of the original message. Must be <em>False</em> for callback queries.'
      end

      it { is_expected.not_to have_key('required_value') }
    end

    context 'with emphasis far from the phrase' do
      let(:description) do
        '<em>Optional</em>. The bot must be an administrator and specify ' \
          '<em>message_reaction</em> in the list of allowed updates.'
      end

      it { is_expected.not_to have_key('required_value') }
    end

    context 'with a bare numeric default' do
      let(:type) { 'Integer' }
      let(:description) { '<em>Optional</em>. Limit. Defaults to 100.' }

      it { is_expected.to include('default' => 100) }
    end

    context 'with an emphasised boolean default' do
      let(:type) { 'Boolean' }
      let(:description) { '<em>Optional</em>. Defaults to <em>true</em>' }

      it { is_expected.to include('default' => true) }
    end

    context 'with a quoted string default' do
      let(:description) { '<em>Optional</em>. Defaults to “mp4”' }

      it { is_expected.to include('default' => 'mp4') }
    end

    # A documented type of True rather than Boolean means the field is only
    # ever present when it is set.
    context 'with a True type' do
      let(:type) { 'True' }
      let(:description) { '<em>Optional</em>. Service message' }

      it { is_expected.to include('default' => true) }
    end

    context 'with a character range' do
      let(:description) { 'Text, 1-64 characters' }

      it { is_expected.to include('min_size' => 1) }

      it { is_expected.to include('max_size' => 64) }
    end

    context 'with a zero-based character range' do
      let(:description) { 'Quote, 0-1024 characters' }

      it { is_expected.to include('max_size' => 1024) }

      it { is_expected.not_to have_key('min_size') }
    end

    # A number carries a value range, not a length, so it gets different keys.
    # dry-types measures `size`, and Integer#size is the byte width, which
    # made every numeric range vacuously true.
    context 'with a numeric range' do
      let(:type) { 'Integer' }
      let(:description) { 'Period, must be between 60 and 86400' }

      it { is_expected.to include('min' => 60) }

      it { is_expected.to include('max' => 86_400) }

      it { is_expected.not_to have_key('min_size') }
    end

    # These limits are measured on the text after markup is parsed, a length
    # the client cannot compute, so enforcing them locally rejects input
    # Telegram accepts.
    context 'with a limit measured after entities parsing' do
      let(:description) { 'Caption of the photo, 0-1024 characters after entities parsing' }

      it { is_expected.not_to have_key('max_size') }
    end

    context 'with a non-string discriminator phrase' do
      let(:type) { 'Integer' }
      let(:description) { 'Identifier, always 42' }

      it { is_expected.not_to have_key('required_value') }
    end

    # data/types.json is written with JSON.pretty_generate, so insertion
    # order is part of the file.
    context 'with every kind of annotation at once' do
      let(:description) { 'Type of the result, always “article”, 1-64 characters' }

      it 'keeps a stable key order' do
        expect(attribute.keys).to eq(%w[type required required_value default min_size max_size])
      end
    end
  end
end
