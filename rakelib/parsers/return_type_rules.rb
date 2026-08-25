# frozen_string_literal: true

module Parsers
  # A method's return type is stated in prose. Each rule pairs a shape (matched
  # against the plain text) with an extractor that pulls the value out of the
  # markup, so "Returns <em>True</em>" and "Returns <a>Message</a>" stay
  # distinguishable.
  #
  # Order is significant, and only two pairs are load-bearing:
  #   * the Array rules must precede :returns_link, or "Array<Update>"
  #     degrades to "Update"
  #   * :edited_or_true must precede :true_flag and :object_returned, or
  #     "Message | Boolean" degrades to "Boolean"
  # Both are asserted in the specs.
  module ReturnTypeRules
    Rule = Struct.new(:name, :shape, :extract) do
      def call(text)
        return nil unless text.match?(shape)

        value = extract.call(text)
        value unless value.nil? || value.to_s.empty?
      end
    end

    def self.rule(name, shape, &extract)
      Rule.new(name, shape, extract)
    end

    ALL = [
      rule(:returns_array_of, /Returns an Array of/i) { |t| wrap_array(t.link_after(/Returns an Array of/i)) },
      rule(:success_array_of, /On success,? an array of/i) { |t| wrap_array(t.link_after(/an Array of/i)) },
      rule(:returns_link, /Returns (?:a |the )?/i) { |t| t.link_following(/Returns/i) },
      rule(:edited_or_true, /is returned,? otherwise True is returned/i) do |t|
        member = t.link_before('is returned')
        member && "#{member} | Boolean"
      end,
      rule(:true_flag, /True(?:\s+(?:is|on)|\s*\.)/) { |t| 'Boolean' if t.emphasised.include?('True') },
      rule(:success_object, /On success,? a .* object is returned/i) { |t| t.link_before('object is returned') },
      rule(:object_returned, /the (?:sent |edited |stopped )?.*? is returned/i) { |t| t.link_before('is returned') },
      rule(:returns_int, /Returns Int(?:eger)?\b/i) do |t|
        'Integer' if %w[Int Integer].include?(t.emphasised_after(/Returns/i))
      end,
      rule(:as_string, /as String/i) { |t| 'String' if t.emphasised_after(/\bas/i) == 'String' }
    ].freeze

    # Returns [rule_name, value], or nil when no rule matches.
    def self.match(text)
      ALL.each do |candidate|
        value = candidate.call(text)
        return [candidate.name, value] if value
      end
      nil
    end

    def self.wrap_array(member)
      member && "Array<#{member}>"
    end
  end
end
