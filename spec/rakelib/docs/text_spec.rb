# frozen_string_literal: true

require 'nokogiri'
require_relative '../../../rakelib/docs'

RSpec.describe Docs::Text do
  def text(html)
    described_class.new(Nokogiri::HTML.fragment("<td>#{html}</td>").at('td'))
  end

  describe '#to_s' do
    it 'is the plain text, with markup flattened' do
      expect(text('Type of the media, must be <em>photo</em>').to_s)
        .to eq('Type of the media, must be photo')
    end

    it 'strips surrounding whitespace' do
      expect(text("\n  hello  \n").to_s).to eq('hello')
    end
  end

  describe '#links' do
    it 'returns the text of each anchor' do
      expect(text('Array of <a href="#PhotoSize">PhotoSize</a>').links).to eq(%w[PhotoSize])
    end

    it 'ignores the empty anchors the docs use as headings targets' do
      expect(text('<a class="anchor" name="x"></a>Array of <a href="#User">User</a>').links)
        .to eq(%w[User])
    end
  end

  describe '#emphasised_after' do
    it 'returns the emphasis immediately following the phrase' do
      expect(text('Scope type, must be <em>default</em>').emphasised_after('must be'))
        .to eq('default')
    end

    it 'ignores emphasis that merely appears later in the sentence' do
      description = text(
        'A reaction to a message was changed. The bot must be an administrator ' \
        'and specify <em>message_reaction</em> in the list of allowed_updates.'
      )

      expect(description.emphasised_after('must be')).to be_nil
    end

    it 'is case sensitive, so conditional prose is not a constraint' do
      # The one real occurrence: a Boolean field whose description reads
      # "... Must be False for callback queries from ephemeral messages".
      description = text('Pass <em>True</em> if shown in place. Must be <em>False</em> for callbacks.')

      expect(description.emphasised_after('must be')).to be_nil
    end

    it 'finds a later occurrence when an earlier one is not followed by emphasis' do
      description = text('The bot must be an administrator. Scope type, must be <em>chat</em>')

      expect(description.emphasised_after('must be')).to eq('chat')
    end
  end

  describe '#quoted_after' do
    it 'accepts typographic quotes' do
      expect(text('Type of the result, always “article”').quoted_after('always')).to eq('article')
    end

    it 'accepts straight quotes' do
      expect(text('Type of the result, always "article"').quoted_after('always')).to eq('article')
    end

    it 'does not treat emphasis as a quoted value' do
      # "Always <em>False</em>" appears in the docs and must yield nothing,
      # otherwise it would become a type constraint.
      expect(text('Always <em>False</em>').quoted_after('always')).to be_nil
    end
  end

  describe '#number_after' do
    it 'reads a bare numeric default' do
      expect(text('Limits the number of updates. Defaults to 100.').number_after('Defaults to'))
        .to eq('100')
    end
  end

  describe '#link_before' do
    it 'returns the last link starting before the phrase' do
      description = text('On success, the sent <a href="#Message">Message</a> is returned.')

      expect(description.link_before('is returned')).to eq('Message')
    end
  end

  describe '#link_following' do
    it 'skips intervening words that #link_after would reject' do
      description = text('Returns basic information about the bot in form of a <a href="#User">User</a> object.')

      expect(description.link_following(/Returns/i)).to eq('User')
    end

    it 'ignores links appearing before the phrase' do
      description = text('See <a href="#Update">Update</a> for details. Returns <a href="#Message">Message</a>.')

      expect(description.link_following(/Returns/i)).to eq('Message')
    end
  end
end
