# frozen_string_literal: true

require_relative '../../../rakelib/docs'
require_relative '../../../rakelib/parsers/types_parser'

RSpec.describe Parsers::TypesParser do
  describe '#parse' do
    subject(:parsed) { described_class.new(page: page).parse }

    let(:page) do
      Docs::Page.new("<html><body><div id='dev_page_content'>#{body}</div></body></html>")
    end

    def union_of(description, members, name: 'RichText')
      items = members.map { |member| %(<li><a href="##{member}">#{member}</a></li>) }.join
      "<h4>#{name}</h4><p>#{description}</p><ul>#{items}</ul>"
    end

    context 'with a union of linked members' do
      let(:body) { union_of('This object represents something.', %w[RichTextBold RichTextItalic]) }

      it { is_expected.to eq('RichText' => { 'type' => %w[RichTextBold RichTextItalic] }) }
    end

    context 'when the prose mentions plain text' do
      let(:body) do
        union_of('This object represents rich text. String for plain text, or one of:', %w[RichTextBold])
      end

      it 'prepends string' do
        expect(parsed.dig('RichText', 'type')).to eq(%w[string RichTextBold])
      end
    end

    context 'when the prose mentions an Array' do
      let(:body) do
        union_of('This object represents rich text as an Array of RichText, or one of:', %w[RichTextBold])
      end

      it 'prepends array:TypeName' do
        expect(parsed.dig('RichText', 'type')).to eq(%w[array:RichText RichTextBold])
      end
    end

    context 'when the prose mentions both' do
      let(:body) do
        union_of(
          'String for plain text, an Array of RichText for sequences, or one of:',
          %w[RichTextBold RichTextItalic]
        )
      end

      it 'keeps string before array' do
        expect(parsed.dig('RichText', 'type')).to eq(%w[string array:RichText RichTextBold RichTextItalic])
      end
    end

    context 'when a member repeats an implied type' do
      let(:body) { union_of('String for plain text or one of:', %w[string RichTextBold]) }

      it 'deduplicates them' do
        expect(parsed.dig('RichText', 'type')).to eq(%w[string RichTextBold])
      end
    end

    context 'with a field table' do
      let(:body) do
        '<h4>Update</h4><p>This object represents an incoming update.</p>' \
          '<table><thead><tr><th>Field</th><th>Type</th><th>Description</th></tr></thead>' \
          '<tbody><tr><td>update_id</td><td>Integer</td><td>The identifier.</td></tr></tbody></table>'
      end

      it { is_expected.to eq('Update' => { 'update_id' => { 'type' => 'integer', 'required' => true } }) }
    end

    context 'when the field table changes shape' do
      let(:body) do
        '<h4>Update</h4>' \
          '<table><thead><tr><th>Field</th><th>Kind</th><th>Notes</th></tr></thead>' \
          '<tbody><tr><td>update_id</td><td>Integer</td><td>x</td></tr></tbody></table>'
      end

      it { expect { parsed }.to raise_error(Docs::Error, /Kind/) }
    end

    context 'with a type that holds no information' do
      let(:body) { '<h4>CallbackGame</h4><p>A placeholder, currently holds no information.</p>' }

      it { is_expected.to eq('CallbackGame' => {}) }
    end

    context 'with a camelCase heading' do
      let(:body) { '<h4>sendMessage</h4><p>Use this method.</p>' }

      it 'ignores it, since it names a method' do
        expect(parsed).to be_empty
      end
    end

    context 'with a prose heading' do
      let(:body) { '<h4>Formatting options</h4><p>Prose.</p>' }

      it { is_expected.to be_empty }
    end
  end
end
