# frozen_string_literal: true

require 'stringio'
require_relative '../../../rakelib/docs'
require_relative '../../../rakelib/parsers/methods_parser'

RSpec.describe Parsers::MethodsParser do
  describe '#parse' do
    subject(:parsed) { parser.parse }

    let(:parser) do
      page = Docs::Page.new("<html><body><div id='dev_page_content'>#{body}</div></body></html>")
      described_class.new(page: page)
    end

    # `warn` writes to $stderr; swallow it where the warning is not the subject.
    def silently
      original = $stderr
      $stderr = StringIO.new
      yield
    ensure
      $stderr = original
    end

    context 'when the first paragraph names it' do
      let(:body) { '<h4>getMe</h4><p>Returns basic information as a <a href="#User">User</a> object.</p>' }

      it { is_expected.to eq('getMe' => 'User') }
    end

    context 'when a later paragraph names it' do
      let(:body) do
        '<h4>sendMessage</h4><p>Use this method to send text messages.</p>' \
          '<p>On success, the sent <a href="#Message">Message</a> is returned.</p>'
      end

      it { is_expected.to eq('sendMessage' => 'Message') }
    end

    context 'with a CapitalCase heading' do
      let(:body) { '<h4>User</h4><p>Returns a <a href="#User">User</a>.</p>' }

      it 'ignores it, since it names a type' do
        expect(parsed).to be_empty
      end
    end

    context 'when every method is understood' do
      let(:body) { '<h4>logOut</h4><p>Returns <em>True</em> on success.</p>' }

      it 'reports nothing unmatched' do
        parsed

        expect(parser.unmatched).to be_empty
      end
    end

    # The old parser dropped an unreadable return type silently, which is how
    # getChatMemberCount went missing from the generated endpoint list.
    context 'when no rule matches' do
      let(:body) { '<h4>getMysteryThing</h4><p>Use this method for something new.</p>' }

      it 'records the method as unmatched' do
        silently { parsed }

        expect(parser.unmatched).to eq(%w[getMysteryThing])
      end

      it 'omits it rather than guessing' do
        expect(silently { parsed }).to be_empty
      end

      it 'warns on stderr' do
        expect { parsed }.to output(/getMysteryThing/).to_stderr
      end
    end
  end
end
