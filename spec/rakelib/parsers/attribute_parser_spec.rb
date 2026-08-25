# frozen_string_literal: true

require 'nokogiri'
require_relative '../../../rakelib/docs'
require_relative '../../../rakelib/parsers/attribute_parser'

RSpec.describe Parsers::AttributeParser do
  # Builds a single "Field | Type | Description" row, the way the docs do.
  def attribute(type, description, field: 'field')
    html = '<table><thead><tr><th>Field</th><th>Type</th><th>Description</th></tr></thead>' \
           "<tbody><tr><td>#{field}</td><td>#{type}</td><td>#{description}</td></tr></tbody></table>"
    row = Docs::Table.new(Nokogiri::HTML.fragment(html).at('table')).first
    described_class.new(row).to_h
  end

  describe 'requiredness' do
    it 'marks a field required when the description does not open with Optional' do
      expect(attribute('Integer', 'Unique identifier')).to eq('type' => 'integer', 'required' => true)
    end

    it 'leaves an optional field unmarked' do
      expect(attribute('Integer', '<em>Optional</em>. Unique identifier')).to eq('type' => 'integer')
    end
  end

  describe 'types' do
    it 'normalizes primitives', :aggregate_failures do
      expect(attribute('String', 'Text')['type']).to eq('string')
      expect(attribute('Float', 'Amount')['type']).to eq('number')
    end

    it 'reads a linked struct type' do
      expect(attribute('<a href="#User">User</a>', 'Sender')['type']).to eq('User')
    end

    it 'reads an array' do
      expect(attribute('Array of <a href="#PhotoSize">PhotoSize</a>', 'Sizes'))
        .to include('type' => 'array', 'items' => 'PhotoSize')
    end

    it 'reads a nested array' do
      expect(attribute('Array of Array of <a href="#PhotoSize">PhotoSize</a>', 'Grid')['items'])
        .to eq('type' => 'array', 'items' => 'PhotoSize')
    end

    it 'reads a union of primitives' do
      expect(attribute('Integer or String', 'Target')['type']).to eq(%w[integer string])
    end
  end

  describe 'discriminators' do
    it 'reads a quoted constant' do
      expect(attribute('String', 'Type of the result, always “article”'))
        .to include('required_value' => 'article', 'default' => 'article')
    end

    it 'reads an emphasised constant' do
      expect(attribute('String', 'Scope type, must be <em>default</em>'))
        .to include('required_value' => 'default', 'default' => 'default')
    end

    # Regression: a Boolean field reading "... Must be False for callback
    # queries ..." once became Bool.constrained(eql: False), which both
    # forbade the True the field exists to carry and emitted a bare constant.
    it 'does not treat sentence-initial conditional prose as a constraint' do
      description = '<em>Optional</em>. Pass <em>True</em> if the ephemeral message must be shown ' \
                    'in place of the original message. Must be <em>False</em> for callback queries.'

      expect(attribute('Boolean', description)).not_to have_key('required_value')
    end

    it 'does not treat a distant emphasis as a constraint' do
      description = '<em>Optional</em>. The bot must be an administrator and specify ' \
                    '<em>message_reaction</em> in the list of allowed updates.'

      expect(attribute('String', description)).not_to have_key('required_value')
    end
  end

  describe 'defaults' do
    it 'reads a bare number' do
      expect(attribute('Integer', '<em>Optional</em>. Limit. Defaults to 100.')['default']).to eq(100)
    end

    it 'reads an emphasised boolean' do
      expect(attribute('Boolean', '<em>Optional</em>. Defaults to <em>true</em>')['default']).to be(true)
    end

    it 'reads a quoted string' do
      expect(attribute('String', '<em>Optional</em>. Defaults to “mp4”')['default']).to eq('mp4')
    end

    it 'defaults a True-typed field to true, since it only exists when set' do
      expect(attribute('True', '<em>Optional</em>. Service message')['default']).to be(true)
    end
  end

  describe 'size constraints' do
    it 'reads a character range' do
      expect(attribute('String', 'Text, 1-64 characters')).to include('min_size' => 1, 'max_size' => 64)
    end

    it 'omits a zero minimum', :aggregate_failures do
      result = attribute('String', 'Quote, 0-1024 characters')

      expect(result).to include('max_size' => 1024)
      expect(result).not_to have_key('min_size')
    end

    it 'reads an explicit range' do
      expect(attribute('Integer', 'Period, must be between 60 and 86400'))
        .to include('min_size' => 60, 'max_size' => 86_400)
    end
  end

  describe 'key order' do
    # data/types.json is written with JSON.pretty_generate, so insertion
    # order is part of the file.
    it 'emits type, required, constraint, size, default in a stable order' do
      result = attribute('String', 'Type of the result, always “article”, 1-64 characters')

      expect(result.keys).to eq(%w[type required required_value default min_size max_size])
    end
  end
end
