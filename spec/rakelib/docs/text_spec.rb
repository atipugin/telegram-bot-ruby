# frozen_string_literal: true

require 'nokogiri'
require_relative '../../../rakelib/docs'

RSpec.describe Docs::Text do
  def text(html)
    described_class.new(Nokogiri::HTML.fragment("<td>#{html}</td>").at('td'))
  end

  describe '#to_s' do
    subject { text(html).to_s }

    context 'with inline markup' do
      let(:html) { 'Type of the media, must be <em>photo</em>' }

      it { is_expected.to eq('Type of the media, must be photo') }
    end

    context 'with surrounding whitespace' do
      let(:html) { "\n  hello  \n" }

      it { is_expected.to eq('hello') }
    end
  end

  describe '#links' do
    subject { text(html).links }

    context 'with a single anchor' do
      let(:html) { 'Array of <a href="#PhotoSize">PhotoSize</a>' }

      it { is_expected.to eq(%w[PhotoSize]) }
    end

    context 'with empty anchor elements' do
      let(:html) { '<a class="anchor" name="x"></a>Array of <a href="#User">User</a>' }

      it { is_expected.to eq(%w[User]) }
    end
  end

  describe '#emphasised_after' do
    subject { text(html).emphasised_after('must be') }

    context 'when the emphasis follows the phrase' do
      let(:html) { 'Scope type, must be <em>default</em>' }

      it { is_expected.to eq('default') }
    end

    context 'when the emphasis only appears later' do
      let(:html) do
        'A reaction to a message was changed. The bot must be an administrator ' \
          'and specify <em>message_reaction</em> in the list of allowed updates.'
      end

      it { is_expected.to be_nil }
    end

    context 'when the phrase is capitalised' do
      # "... Must be False for callback queries" is conditional prose rather
      # than a constraint, and reading it as one produced a Boolean field
      # constrained to eql: False.
      let(:html) { 'Pass <em>True</em> if shown in place. Must be <em>False</em> for callbacks.' }

      it { is_expected.to be_nil }
    end

    context 'when an earlier phrase has no emphasis' do
      let(:html) { 'The bot must be an administrator. Scope type, must be <em>chat</em>' }

      it { is_expected.to eq('chat') }
    end
  end

  describe '#quoted_after' do
    subject { text(html).quoted_after('always') }

    context 'with typographic quotes' do
      let(:html) { 'Type of the result, always “article”' }

      it { is_expected.to eq('article') }
    end

    context 'with straight quotes' do
      let(:html) { 'Type of the result, always "article"' }

      it { is_expected.to eq('article') }
    end

    context 'when the value is emphasised instead' do
      let(:html) { 'Always <em>False</em>' }

      it { is_expected.to be_nil }
    end
  end

  describe '#number_after' do
    subject { text(html).number_after('Defaults to') }

    let(:html) { 'Limits the number of updates. Defaults to 100.' }

    it { is_expected.to eq('100') }
  end

  describe '#link_before' do
    subject { text(html).link_before('is returned') }

    let(:html) { 'On success, the sent <a href="#Message">Message</a> is returned.' }

    it { is_expected.to eq('Message') }
  end

  describe '#link_following' do
    subject { text(html).link_following(/Returns/i) }

    context 'with words before the link' do
      let(:html) { 'Returns basic information about the bot in form of a <a href="#User">User</a> object.' }

      it { is_expected.to eq('User') }
    end

    context 'with a link before the phrase' do
      let(:html) { 'See <a href="#Update">Update</a> for details. Returns <a href="#Message">Message</a>.' }

      it { is_expected.to eq('Message') }
    end
  end
end
