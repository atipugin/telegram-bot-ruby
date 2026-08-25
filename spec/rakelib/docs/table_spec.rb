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
  let(:parameters) { table(%w[Parameter Type Required Description], %w[chat_id Integer Yes Target]) }

  describe '#columns' do
    subject { fields.columns }

    it { is_expected.to eq(%w[Field Type Description]) }
  end

  describe '#[]' do
    subject(:row) { fields.first }

    it 'reads the first column' do
      expect(row['Field'].to_s).to eq('update_id')
    end

    it 'reads a middle column' do
      expect(row['Type'].to_s).to eq('Integer')
    end

    it 'reads the last column' do
      expect(row['Description'].to_s).to eq('The update id')
    end
  end

  describe '#expect_columns!' do
    subject(:assert) { subject_table.expect_columns!(%w[Field Type Description]) }

    context 'when the columns match' do
      let(:subject_table) { fields }

      it { is_expected.to be(fields) }
    end

    # Method tables carry a fourth "Required" column. Reading one with the
    # three-column layout used to silently yield "Optional" as the description.
    context 'when the table has a different shape' do
      let(:subject_table) { parameters }

      it { expect { assert }.to raise_error(Docs::Error, /Parameter/) }
    end
  end
end
