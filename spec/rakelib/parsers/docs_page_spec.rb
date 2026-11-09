# frozen_string_literal: true

require_relative 'snapshot_page'

RSpec.describe Parsers::DocsPage do
  subject(:page) { SnapshotPage.page }

  def page_with(content)
    described_class.parse(%(<div id="dev_page_content">#{content}</div>))
  end

  def fields_table(rows)
    "<table><thead><tr><th>Field</th><th>Type</th><th>Description</th></tr></thead><tbody>#{rows}</tbody></table>"
  end

  describe '.parse' do
    it 'raises when the document has no content' do
      expect { described_class.parse('<p>Not found</p>') }.to raise_error(Parsers::Error, /dev_page_content/)
    end

    it 'reads a snapshot back unchanged' do
      expect(page.to_html).to eq(File.read(described_class::SNAPSHOT_PATH))
    end
  end

  describe '#api_types' do
    it 'skips methods and prose headings' do
      names = page.api_types.map(&:name)

      expect(names & ['Update', 'InputFile', 'getMe', 'Sending files']).to eq(%w[Update InputFile])
    end

    it 'only references types that are defined' do
      referenced = page.api_types.flat_map do |type|
        type.is_a?(Parsers::UnionType) ? type.members : type.fields.flat_map { |field| field.type.names }
      end

      expect(referenced.uniq - page.api_types.map(&:name)).to match_array(%w[Integer String Boolean True Float])
    end

    it 'raises on a table without rows' do
      broken = page_with('<h4>Foo</h4><table><tr><th>Field</th><th>Type</th><th>Description</th></tr></table>')

      expect { broken.api_types }.to raise_error(Parsers::Error, /Foo: has a table without rows/)
    end

    it 'raises on a heading that is neither a type, a method nor prose' do
      broken = page_with('<h4>get_foo</h4><p>Returns <em>True</em> on success.</p>')

      expect { broken.entries }.to raise_error(Parsers::Error, /Unrecognised heading "get_foo"/)
    end

    context 'with a table of fields' do
      subject(:type) { page.api_type('User') }

      it 'reads fields in the documented order' do
        expect(type.fields.first(4).map(&:name)).to eq(%w[id is_bot first_name last_name])
      end

      it 'tells required fields from optional ones' do
        expect(type.fields.select(&:required?).map(&:name)).to eq(%w[id is_bot first_name])
      end
    end

    context 'with a list of members' do
      subject(:type) { page.api_type('MessageOrigin') }

      it 'is a union of the listed types' do
        expect(type.members).to eq(%w[MessageOriginUser MessageOriginHiddenUser MessageOriginChat MessageOriginChannel])
      end

      it 'accepts neither strings nor arrays' do
        expect([type.accepts_string?, type.accepts_array_of_self?]).to eq([false, false])
      end
    end

    context 'with a union described in prose' do
      subject(:type) { page.api_type('RichText') }

      it 'accepts a plain string' do
        expect(type).to be_accepts_string
      end

      it 'accepts an array of itself' do
        expect(type).to be_accepts_array_of_self
      end

      it 'still lists its members' do
        expect(type.members).to include('RichTextBold', 'RichTextItalic')
      end
    end

    context 'without fields or members' do
      subject(:type) { page.api_type('ForumTopicClosed') }

      it 'is an object with no fields' do
        expect([type.class, type.fields]).to eq([Parsers::ObjectType, []])
      end
    end

    it 'raises on a table with unexpected columns' do
      broken = page_with('<h4>Foo</h4><table><thead><tr><th>Field</th><th>Type</th></tr></thead>' \
                         '<tbody><tr><td>id</td><td>Integer</td></tr></tbody></table>')

      expect { broken.api_types }.to raise_error(Parsers::Error, /Foo: has unexpected table headers/)
    end

    it 'raises on a type with both a table and a list' do
      table = fields_table('<tr><td>id</td><td>Integer</td><td>Identifier</td></tr>')
      broken = page_with(%(<h4>Foo</h4><ul><li><a href="#bar">Bar</a></li></ul>#{table}))

      expect { broken.api_types }.to raise_error(Parsers::Error, /Foo: has both/)
    end

    it 'raises on a type with neither a table nor a list but more than paragraphs' do
      broken = page_with('<h4>Foo</h4><p>One of:</p><ol><li><a href="#bar">Bar</a></li></ol>')

      expect { broken.api_types }.to raise_error(Parsers::Error, /Foo: has no table/)
    end
  end

  describe 'fields' do
    def field(type, name)
      page.api_type(type).fields.find { |field| field.name == name }
    end

    it 'reads a nested array type' do
      type = field('InlineKeyboardMarkup', 'inline_keyboard').type

      expect([type.array?, type.items.array?, type.items.items.names]).to eq([true, true, %w[InlineKeyboardButton]])
    end

    it 'reads a union type' do
      expect(field('ReplyParameters', 'chat_id').type.names).to eq(%w[Integer String])
    end

    it 'tells True from Boolean' do
      always_true = [field('User', 'is_premium'), field('User', 'is_bot')].map { |field| field.type.always_true? }

      expect(always_true).to eq([true, false])
    end

    it 'reads a fixed value' do
      expect(field('InputMediaPhoto', 'type').description.fixed_value).to eq('photo')
    end

    it 'ignores a value that is required only under a condition' do
      description = field('EphemeralMessageParameters', 'replace_callback_query_message').description

      expect([description.fixed_value, description.default]).to eq([nil, nil])
    end

    it 'reads a default value' do
      expect(field('KeyboardButtonRequestUsers', 'max_quantity').description.default).to eq('1')
    end

    it 'reads size limits' do
      description = field('PollOption', 'text').description

      expect([description.min_size, description.max_size]).to eq([1, 100])
    end

    it 'does not read number ranges as size limits' do
      description = field('InputLocationMessageContent', 'live_period').description

      expect([description.min_size, description.max_size]).to eq([nil, nil])
    end

    {
      %w[InputLocationMessageContent heading] => [[1, 360]],
      %w[InputLocationMessageContent live_period] => [[60, 86_400], [0x7FFFFFFF, 0x7FFFFFFF]],
      %w[SuggestedPostPrice amount] => [[5, 100_000], [10_000_000, 10_000_000_000_000]]
    }.each do |(type, name), ranges|
      it "reads the allowed values of #{type}.#{name}" do
        expect(field(type, name).description.ranges).to eq(ranges)
      end
    end

    it 'raises on a row with a missing cell' do
      broken = page_with("<h4>Foo</h4>#{fields_table('<tr><td>id</td><td>Integer</td></tr>')}")

      expect { broken.api_types }.to raise_error(Parsers::Error, /Foo: No cell 2/)
    end

    it 'raises on a type it cannot read' do
      row = '<tr><td>id</td><td>Integer, String</td><td>Identifier</td></tr>'
      broken = page_with("<h4>Foo</h4>#{fields_table(row)}")

      expect { broken.api_types }.to raise_error(Parsers::Error, /Foo: Unsupported type "Integer, String"/)
    end
  end

  describe '#api_methods' do
    {
      'getMe' => 'User',
      'getUpdates' => 'Array<Update>',
      'sendMessage' => 'Message',
      'setWebhook' => 'Boolean',
      'editMessageText' => 'Message | Boolean',
      'exportChatInviteLink' => 'String',
      'getChatMemberCount' => 'Integer',
      'copyMessage' => 'MessageId',
      'forwardMessages' => 'Array<MessageId>'
    }.each do |name, return_type|
      it "reads that #{name} returns #{return_type}" do
        expect(page.api_method(name).return_type).to eq(return_type)
      end
    end

    it 'skips types and prose headings' do
      names = page.api_methods.map(&:name)

      expect(names & ['getMe', 'close', 'Update', 'Sending files']).to eq(%w[getMe close])
    end

    it 'raises on a method that does not state what it returns' do
      broken = page_with('<h4>getFoo</h4><p>Use this method to get a <a href="#foo">Foo</a>.</p>')

      expect { broken.api_methods }.to raise_error(Parsers::Error, /getFoo: cannot find the return type/)
    end
  end
end
