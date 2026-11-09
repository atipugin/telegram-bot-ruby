# frozen_string_literal: true

require_relative 'snapshot_page'

RSpec.describe Parsers::Serializer do
  subject(:serializer) { described_class.new(SnapshotPage.page) }

  described_class::FILES.each_key do |file|
    it "generates data/#{file}.json from data/bot_api.html" do
      expect(serializer.render(file)).to eq(File.read(described_class.path(file)))
    end
  end

  it 'only returns types that are defined' do
    returned = serializer.api_methods.values.flat_map { |type| type.scan(/#{Parsers::TypeRef::NAME_PATTERN}/o) }

    expect(returned.uniq - SnapshotPage.page.api_types.map(&:name)).to match_array(%w[Array Boolean Integer String])
  end
end
