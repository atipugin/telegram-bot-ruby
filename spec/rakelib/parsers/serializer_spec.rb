# frozen_string_literal: true

require_relative 'snapshot_page'

RSpec.describe Parsers::Serializer do
  subject(:serializer) { described_class.new(SnapshotPage.page) }

  described_class::FILES.each_key do |file|
    it "generates data/#{file}.json from data/bot_api.html" do
      expect(serializer.render(file)).to eq(File.read(described_class.path(file)))
    end
  end

  context 'with a fixed value that is not a string' do
    subject(:serializer) { described_class.new(Parsers::DocsPage.parse(html)) }

    let(:html) do
      '<div id="dev_page_content"><h4>Foo</h4><table>' \
        '<thead><tr><th>Field</th><th>Type</th><th>Description</th></tr></thead>' \
        '<tbody><tr><td>is_enabled</td><td>Boolean</td><td>Must be <em>True</em></td></tr></tbody>' \
        '</table></div>'
    end

    it 'casts it to the field type' do
      expect(serializer.types['Foo']['is_enabled']).to include('required_value' => true, 'default' => true)
    end
  end

  it 'only returns types that are defined' do
    returned = serializer.api_methods.values.flat_map { |type| type.scan(/#{Parsers::TypeRef::NAME_PATTERN}/o) }

    expect(returned.uniq - SnapshotPage.page.api_types.map(&:name)).to match_array(%w[Array Boolean Integer String])
  end
end
