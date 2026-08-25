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
    # `must be` is matched case-sensitively and only when the <em> follows it
    # immediately. All 57 real discriminators are lowercase and mid-sentence;
    # the one false positive is a sentence-initial "Must be <em>False</em>" of
    # conditional prose. That distinction is what the pattern keys on, so no
    # type-specific carve-out is needed.
    def apply_constant(attribute)
      value = constant(attribute['type'])
      return unless value

      attribute['required_value'] = value
      attribute['default'] = value
    end

    def constant(type)
      quoted = @description.quoted_after('always')
      return cast(quoted.delete('\\'), type) if quoted

      emphasised = @description.emphasised_after('must be')
      emphasised && cast(emphasised, type)
    end

    def apply_size(attribute)
      minimum, maximum = size_range
      return unless maximum

      attribute['min_size'] = minimum if minimum
      attribute['max_size'] = maximum
    end

    def size_range
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
