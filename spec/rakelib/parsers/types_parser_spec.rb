# frozen_string_literal: true

require_relative '../../../rakelib/docs'
require_relative '../../../rakelib/parsers/types_parser'

RSpec.describe Parsers::TypesParser do
  def parse(body)
    page = Docs::Page.new("<html><body><div id='dev_page_content'>#{body}</div></body></html>")
    described_class.new(page: page).parse
  end

  def union(description, members, name: 'RichText')
    items = members.map { |member| %(<li><a href="##{member}">#{member}</a></li>) }.join
    parse("<h4>#{name}</h4><p>#{description}</p><ul>#{items}</ul>").fetch(name)
  end

  describe 'union types' do
    it 'collects the linked members' do
      result = union('This object represents something.', %w[RichTextBold RichTextItalic])

      expect(result).to eq('type' => %w[RichTextBold RichTextItalic])
    end

    it 'prepends string when the prose mentions plain text' do
      result = union('This object represents rich text. String for plain text, or one of:', %w[RichTextBold])

      expect(result['type']).to eq(%w[string RichTextBold])
    end

    it 'prepends array:TypeName when the prose mentions an Array of the type' do
      result = union('This object represents rich text as an Array of RichText, or one of:', %w[RichTextBold])

      expect(result['type']).to eq(%w[array:RichText RichTextBold])
    end

    it 'keeps string before array when both are described' do
      result = union(
        'String for plain text, an Array of RichText for sequences, or one of:',
        %w[RichTextBold RichTextItalic]
      )

      expect(result['type']).to eq(%w[string array:RichText RichTextBold RichTextItalic])
    end

    it 'deduplicates members' do
      result = union('String for plain text or one of:', %w[string RichTextBold])

      expect(result['type']).to eq(%w[string RichTextBold])
    end
  end

  describe 'struct types' do
    let(:update) do
      '<h4>Update</h4><p>This object represents an incoming update.</p>' \
        '<table><thead><tr><th>Field</th><th>Type</th><th>Description</th></tr></thead>' \
        '<tbody><tr><td>update_id</td><td>Integer</td><td>The identifier.</td></tr></tbody></table>'
    end

    let(:renamed_columns) do
      '<h4>Update</h4>' \
        '<table><thead><tr><th>Field</th><th>Kind</th><th>Notes</th></tr></thead>' \
        '<tbody><tr><td>update_id</td><td>Integer</td><td>x</td></tr></tbody></table>'
    end

    it 'reads the field table' do
      expect(parse(update)).to eq('Update' => { 'update_id' => { 'type' => 'integer', 'required' => true } })
    end

    it 'raises when the field table changes shape' do
      expect { parse(renamed_columns) }.to raise_error(Docs::Error, /Kind/)
    end
  end

  describe 'marker types' do
    it 'yields no attributes for a type that holds no information' do
      result = parse('<h4>CallbackGame</h4><p>A placeholder, currently holds no information.</p>')

      expect(result).to eq('CallbackGame' => {})
    end
  end

  describe 'selection' do
    it 'ignores camelCase headings, which are methods' do
      expect(parse('<h4>sendMessage</h4><p>Use this method.</p>')).to be_empty
    end

    it 'ignores prose headings' do
      expect(parse('<h4>Formatting options</h4><p>Prose.</p>')).to be_empty
    end
  end
end
