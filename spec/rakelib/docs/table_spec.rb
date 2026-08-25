# frozen_string_literal: true

require 'nokogiri'
require_relative '../../../rakelib/docs'

RSpec.describe Docs::Table do
  def table(head, *rows)
    body = rows.map { |cells| "<tr>#{cells.map { |cell| "<td>#{cell}</td>" }.join}</tr>" }.join
    html = "<table><thead><tr>#{head.map { |cell| "<th>#{cell}</th>" }.join}</tr></thead>" \
           "<tbody>#{body}</tbody></table>"
    described_class.new(Nokogiri::HTML.fragment(html).at('table'))
  end

  let(:fields) { table(%w[Field Type Description], ['update_id', 'Integer', 'The update id']) }

  describe '#columns' do
    it 'reads the header row' do
      expect(fields.columns).to eq(%w[Field Type Description])
    end
  end

  describe 'row access' do
    it 'addresses cells by column name', :aggregate_failures do
      row = fields.first

      expect(row['Field'].to_s).to eq('update_id')
      expect(row['Type'].to_s).to eq('Integer')
      expect(row['Description'].to_s).to eq('The update id')
    end
  end

  describe '#expect_columns!' do
    it 'returns the table when the columns match' do
      expect(fields.expect_columns!(%w[Field Type Description])).to be(fields)
    end

    # Method tables carry a fourth "Required" column. Reading one with the
    # three-column layout used to silently yield "Optional" as the description.
    it 'raises when handed a table of a different shape' do
      parameters = table(%w[Parameter Type Required Description], %w[chat_id Integer Yes Target])

      expect { parameters.expect_columns!(%w[Field Type Description]) }
        .to raise_error(Docs::Error, /Parameter/)
    end
  end
end
