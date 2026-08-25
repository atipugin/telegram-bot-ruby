# frozen_string_literal: true

require 'stringio'
require_relative '../../../rakelib/docs'
require_relative '../../../rakelib/parsers/methods_parser'

RSpec.describe Parsers::MethodsParser do
  def build(body)
    page = Docs::Page.new("<html><body><div id='dev_page_content'>#{body}</div></body></html>")
    described_class.new(page: page)
  end

  def parse(body)
    build(body).parse
  end

  # `warn` writes to $stderr; swallow it where the warning is not the subject.
  def silently
    original = $stderr
    $stderr = StringIO.new
    yield
  ensure
    $stderr = original
  end

  it 'reads the return type from the description' do
    result = parse('<h4>getMe</h4><p>Returns basic information as a <a href="#User">User</a> object.</p>')

    expect(result).to eq('getMe' => 'User')
  end

  context 'when the first paragraph says nothing about the return type' do
    let(:html) do
      '<h4>sendMessage</h4><p>Use this method to send text messages.</p>' \
        '<p>On success, the sent <a href="#Message">Message</a> is returned.</p>'
    end

    it 'scans later paragraphs' do
      expect(parse(html)).to eq('sendMessage' => 'Message')
    end
  end

  it 'ignores CapitalCase headings, which are types' do
    expect(parse('<h4>User</h4><p>Returns a <a href="#User">User</a>.</p>')).to be_empty
  end

  describe 'when no rule matches' do
    subject(:parser) { build('<h4>getMysteryThing</h4><p>Use this method for something new.</p>') }

    # The old parser dropped these silently, which is how getChatMemberCount
    # went missing from the generated endpoint list.
    it 'records the method as unmatched' do
      silently { parser.parse }

      expect(parser.unmatched).to eq(%w[getMysteryThing])
    end

    it 'omits it from the result rather than guessing' do
      expect(silently { parser.parse }).to be_empty
    end

    it 'warns on stderr' do
      expect { parser.parse }.to output(/getMysteryThing/).to_stderr
    end
  end

  it 'reports nothing unmatched when every method is understood' do
    parser = build('<h4>logOut</h4><p>Returns <em>True</em> on success.</p>')
    parser.parse

    expect(parser.unmatched).to be_empty
  end
end
