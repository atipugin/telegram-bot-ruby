# frozen_string_literal: true

require_relative '../../../rakelib/docs'

RSpec.describe Docs::Page do
  def page(body)
    described_class.new("<html><body><div id='dev_page_content'>#{body}</div></body></html>")
  end

  describe '.new' do
    context 'without the content container' do
      subject(:build) { described_class.new('<html><body><p>nope</p></body></html>') }

      it { expect { build }.to raise_error(Docs::Error, /dev_page_content/) }
    end
  end

  describe '#sections' do
    subject(:sections) { page(body).sections }

    context 'with a heading followed by content' do
      let(:body) { '<h4>User</h4><p>An object.</p><table></table>' }

      it 'finds the section' do
        expect(sections.map(&:title)).to eq(%w[User])
      end

      it 'gathers the nodes that follow' do
        expect(sections.first.nodes.map(&:name)).to eq(%w[p table])
      end
    end

    context 'when a same-level heading follows' do
      let(:body) { '<h4>User</h4><p>first</p><h4>Chat</h4><p>second</p>' }

      it 'finds both sections' do
        expect(sections.map(&:title)).to eq(%w[User Chat])
      end

      it 'ends the first section at the second' do
        expect(sections.first.paragraphs.map(&:to_s)).to eq(%w[first])
      end
    end

    context 'when a heading of a higher level follows' do
      let(:body) { '<h4>User</h4><p>mine</p><h3>Available methods</h3><p>theirs</p>' }

      it 'ends the section there' do
        expect(sections.first.paragraphs.map(&:to_s)).to eq(%w[mine])
      end
    end

    context 'with content before the first heading' do
      let(:body) { '<p>preamble</p><h4>User</h4>' }

      it 'ignores it' do
        expect(sections.map(&:title)).to eq(%w[User])
      end
    end

    context 'when another level is requested' do
      subject(:sections) { page(body).sections(level: 3) }

      let(:body) { '<h3>Available types</h3><p>intro</p><h4>User</h4>' }

      it 'selects headings at that level' do
        expect(sections.map(&:title)).to eq(['Available types'])
      end
    end
  end
end
