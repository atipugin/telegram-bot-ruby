# frozen_string_literal: true

require 'nokogiri'
require_relative '../../../rakelib/docs'
require_relative '../../../rakelib/parsers/return_type_rules'

RSpec.describe Parsers::ReturnTypeRules do
  def paragraph(html)
    Docs::Text.new(Nokogiri::HTML.fragment("<p>#{html}</p>").at('p'))
  end

  def match(html)
    described_class.match(paragraph(html))
  end

  # One example per rule, so a rule that stops working fails on its own name
  # rather than somewhere downstream in data/methods.json.
  {
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
    true_flag: [
      'On success, <em>True</em> is returned.', 'Boolean'
    ],
    success_object: [
      'On success, a <a href="#WebhookInfo">WebhookInfo</a> object is returned.', 'WebhookInfo'
    ],
    object_returned: [
      'On success, the sent <a href="#Message">Message</a> is returned.', 'Message'
    ],
    returns_int: [
      'Use this method to get the number of members in a chat. Returns <em>Integer</em> on success.', 'Integer'
    ],
    as_string: [
      'Returns the new invite link as <em>String</em> on success.', 'String'
    ]
  }.each do |name, (html, expected)|
    it "matches #{name}" do
      expect(match(html)).to eq([name, expected])
    end
  end

  it 'covers every rule' do
    # A rule with no example above is either dead or untested; both are bugs.
    expect(described_class::ALL.map(&:name)).to contain_exactly(
      :returns_array_of, :success_array_of, :returns_link, :edited_or_true,
      :true_flag, :success_object, :object_returned, :returns_int, :as_string
    )
  end

  it 'returns nil when nothing matches' do
    expect(match('Use this method to do something undocumented.')).to be_nil
  end

  describe 'ordering' do
    def index_of(name)
      described_class::ALL.index { |rule| rule.name == name }
    end

    it 'tries the array rules before the generic link rule', :aggregate_failures do
      expect(index_of(:returns_array_of)).to be < index_of(:returns_link)
      expect(index_of(:success_array_of)).to be < index_of(:returns_link)
    end

    it 'tries the union rule before the plain True and object rules', :aggregate_failures do
      expect(index_of(:edited_or_true)).to be < index_of(:true_flag)
      expect(index_of(:edited_or_true)).to be < index_of(:object_returned)
    end
  end
end
