# frozen_string_literal: true

require 'nokogiri'
require_relative '../../../rakelib/docs'
require_relative '../../../rakelib/parsers/return_type_rules'

RSpec.describe Parsers::ReturnTypeRules do
  # One example per rule, so a rule that stops working fails under its own
  # name rather than somewhere downstream in data/methods.json.
  examples = {
    returns_array_of: [
      'Returns an Array of <a href="#Update">Update</a> objects.', 'Array<Update>'
    ],
    success_array_of: [
      'On success, an Array of <a href="#MessageId">MessageId</a> of the sent messages is returned.',
      'Array<MessageId>'
    ],
    returns_link: [
      'Returns basic information about the bot in form of a <a href="#User">User</a> object.', 'User'
    ],
    edited_or_true: [
      'On success, the edited <a href="#Message">Message</a> is returned, otherwise <em>True</em> is returned.',
      'Message | Boolean'
    ],
    true_flag: ['On success, <em>True</em> is returned.', 'Boolean'],
    success_object: ['On success, a <a href="#WebhookInfo">WebhookInfo</a> object is returned.', 'WebhookInfo'],
    object_returned: ['On success, the sent <a href="#Message">Message</a> is returned.', 'Message'],
    returns_int: ['Returns <em>Integer</em> on success.', 'Integer'],
    as_string: ['Returns the new invite link as <em>String</em> on success.', 'String']
  }

  describe '.match' do
    subject(:matched) { described_class.match(paragraph) }

    let(:paragraph) { Docs::Text.new(Nokogiri::HTML.fragment("<p>#{html}</p>").at('p')) }

    examples.each do |name, (example_html, expected)|
      context "with prose matching #{name}" do
        let(:html) { example_html }

        it { is_expected.to eq([name, expected]) }
      end
    end

    context 'when nothing matches' do
      let(:html) { 'Use this method to do something undocumented.' }

      it { is_expected.to be_nil }
    end
  end

  describe '::ALL' do
    subject(:names) { described_class::ALL.map(&:name) }

    def index_of(name)
      names.index(name)
    end

    it 'has an example for every rule' do
      expect(names).to match_array(examples.keys)
    end

    context 'with the array rules' do
      it 'tries Returns an Array of first' do
        expect(index_of(:returns_array_of)).to be < index_of(:returns_link)
      end

      it 'tries an array of first' do
        expect(index_of(:success_array_of)).to be < index_of(:returns_link)
      end
    end

    context 'with the union rule' do
      it 'runs before the plain True rule' do
        expect(index_of(:edited_or_true)).to be < index_of(:true_flag)
      end

      it 'runs before the object rule' do
        expect(index_of(:edited_or_true)).to be < index_of(:object_returned)
      end
    end
  end
end
