# frozen_string_literal: true

require_relative 'type_value'

module Parsers
  # Turns one row of a "Field | Type | Description" table into the attribute
  # hash stored in data/types.json.
  #
  # Key insertion order is significant: the file is written with
  # JSON.pretty_generate, so the order below is part of the output.
  class AttributeParser
    CHARACTER_RANGE = /(\d+)-(\d+) characters/.freeze
    BOUNDED_RANGE = /must be between (\d+) and (\d+)/.freeze
    # Limits worded this way are measured on the text after markup is parsed,
    # a length the client cannot compute: "<b>x</b>" is 8 raw characters and 1
    # parsed. Enforcing them locally rejects input Telegram accepts, so they
    # are not emitted at all.
    PARSED_LENGTH = /after entities parsing/.freeze

    def initialize(row)
      @type = row['Type']
      @description = row['Description']
    end

    def to_h
      attribute = TypeValue.new(@type).to_h
      attribute['required'] = true unless optional?
      apply_constant(attribute)
      apply_size(attribute)
      apply_default(attribute)
      attribute
    end

    private

    def optional?
      @description.start_with?('Optional')
    end

    # A discriminator: `always "photo"` or `..., must be <em>photo</em>`.
    #
    # Two independent guards, since either alone has failed before. The type
    # check states what a discriminator is. `must be` is then matched
    # case-sensitively and only when the <em> follows it immediately: all 57
    # real discriminators are lowercase and mid-sentence, and the known false
    # positive is a sentence-initial "Must be <em>False</em>" of conditional
    # prose.
    def apply_constant(attribute)
      value = constant(attribute['type'])
      return unless value

      attribute['required_value'] = value
      attribute['default'] = value
    end

    def constant(type)
      # required_value becomes .constrained(eql: 'photo'), which is only
      # coherent for a string discriminator; all 176 in the docs are strings.
      return nil unless type == 'string'

      quoted = @description.quoted_after('always')
      return quoted.delete('\\') if quoted

      @description.emphasised_after('must be')
    end

    # A string carries a length limit, a number a value range. They are
    # different constraints, so they get different keys rather than leaving
    # the builder to infer one from the type.
    def apply_size(attribute)
      minimum, maximum = size_range
      return unless maximum

      low, high = attribute['type'] == 'integer' ? %w[min max] : %w[min_size max_size]
      attribute[low] = minimum if minimum
      attribute[high] = maximum
    end

    def size_range
      return [nil, nil] if @description.match?(PARSED_LENGTH)

      if (found = @description.match(CHARACTER_RANGE))
        minimum = found[1].to_i
        [(minimum if minimum.positive?), found[2].to_i]
      elsif (found = @description.match(BOUNDED_RANGE))
        [found[1].to_i, found[2].to_i]
      else
        [nil, nil]
      end
    end

    def apply_default(attribute)
      return if attribute.key?('default')
      # A documented type of "True" rather than "Boolean" means the field is
      # only ever present when it is true.
      return attribute['default'] = true if @type.to_s == 'True'

      value = default_value(attribute['type'])
      attribute['default'] = value unless value.nil?
    end

    def default_value(type)
      raw = @description.quoted_after('Defaults to') ||
            @description.emphasised_after('Defaults to') ||
            @description.number_after('Defaults to')
      raw && cast(raw, type)
    end

    def cast(value, type)
      case type
      when 'integer' then value.to_i
      when 'boolean' then value.downcase == 'true'
      when 'number' then value.to_f
      else value
      end
    end
  end
end
