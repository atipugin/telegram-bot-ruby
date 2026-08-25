# frozen_string_literal: true

require_relative '../../../rakelib/docs'

RSpec.describe Docs::Page do
  def page(body)
    described_class.new("<html><body><div id='dev_page_content'>#{body}</div></body></html>")
  end

  describe '#sections' do
    it 'gathers the nodes that follow a heading', :aggregate_failures do
      sections = page('<h4>User</h4><p>An object.</p><table></table>').sections

      expect(sections.map(&:title)).to eq(%w[User])
      expect(sections.first.nodes.map(&:name)).to eq(%w[p table])
    end

    it 'ends a section at the next heading of the same level', :aggregate_failures do
      sections = page('<h4>User</h4><p>first</p><h4>Chat</h4><p>second</p>').sections

      expect(sections.map(&:title)).to eq(%w[User Chat])
      expect(sections.map { |section| section.paragraphs.map(&:to_s) }).to eq([%w[first], %w[second]])
    end

    it 'ends a section at a heading of a higher level' do
      sections = page('<h4>User</h4><p>mine</p><h3>Available methods</h3><p>theirs</p>').sections

      expect(sections.map { |section| section.paragraphs.map(&:to_s) }).to eq([%w[mine]])
    end

    it 'ignores content before the first heading' do
      expect(page('<p>preamble</p><h4>User</h4>').sections.map(&:title)).to eq(%w[User])
    end

    it 'selects the requested heading level' do
      sections = page('<h3>Available types</h3><p>intro</p><h4>User</h4>').sections(level: 3)

      expect(sections.map(&:title)).to eq(['Available types'])
    end

    it 'raises when the content container is missing' do
      expect { described_class.new('<html><body><p>nope</p></body></html>') }
        .to raise_error(Docs::Error, /dev_page_content/)
    end
  end
end
