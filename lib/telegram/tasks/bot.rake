require 'telegram/bot'

namespace :telegram do
  namespace :bot do
    desc 'Check if current methods are up to date'
    task :check_methods do
      expected_methods = headers.reject { |h| /^[[:upper:]]/.match(h) }
      current_methods  = Telegram::Bot::Api::ENDPOINTS

      print_report report(
        kind: :missing,
        expected: expected_methods,
        current: current_methods
      )
      print_report report(
        kind: :extra,
        expected: expected_methods,
        current: current_methods
      )
    end

    desc 'Check if current types are up to date'
    task :check_types do
      expected = expected_types
      current  = current_types

      print_report report(
        kind: :missing,
        expected: expected,
        current: current
      )
      print_report report(
        kind: :extra,
        expected: expected,
        current: current
      )
    end

    desc 'Check if current attributes are up to date'
    task :check_attributes, :types do |_, args|
      args.with_defaults(types: [])
      docs = documentation

      expected = Hash.new { |hash, key| hash[key] = {} }
      current  = Hash.new { |hash, key| hash[key] = {} }

      types = args[:types].empty? ? current_types : args[:types].split
      types.each do |type_name|
        # Expected attributes
        attr_rows = docs.xpath(<<-XPATH)
          //table[@class='table'][preceding::h4[text()='#{type_name}']][1]
            /tbody
              /tr[position()>1]
        XPATH
        next if attr_rows.empty?

        expected[type_name] = attr_rows.each_with_object({}) do |attr, acc|
          attr_name = attr.xpath('./td[1]').text
          attr_type = attr.xpath('./td[2]').text
          acc[attr_name.to_sym] = attr_type
        end

        # Current attributes
        type =
          begin
            Telegram::Bot::Types.const_get(type_name)
          rescue NameError
            nil
          end
        next if type.nil?

        current[type_name] = type.attribute_set
                                 .each_with_object({}) do |attr, acc|

          declared_type = attr.type
          attr_name = attr.name
          attr_type =
            if declared_type.instance_of?(Virtus::Attribute::Collection::Type)
              if declared_type.primitive == Array
                "Array of #{declared_type.member_type.name.split('::').last}"
              end

            elsif declared_type < Axiom::Types::Type
              if declared_type == Axiom::Types::Boolean
                'Boolean'
              else
                declared_type.primitive.name.split('::').last
              end
            end

          acc[attr_name] = attr_type
        end
      end

      both_present_types = expected.keys & current.keys
      both_present_types.each do |type|
        expected_attrs = expected[type]
        current_attrs  = current[type]

        reports = []

        reports << report(
          kind: :missing,
          expected: expected_attrs.keys,
          current: current_attrs.keys,
          indent: 1
        )

        reports << report(
          kind: :extra,
          expected: expected_attrs.keys,
          current: current_attrs.keys,
          indent: 1
        )

        reports << report_type_mismatch(
          expected: expected_attrs,
          current: current_attrs,
          indent: 1
        )

        reports.reject!(&:empty?)
        next if reports.empty?

        puts "#{type}:"
        reports.each { |r| print_report(r) }
      end
    end

    def documentation
      require 'nokogiri'
      require 'open-uri'

      url = 'https://core.telegram.org/bots/api'
      Nokogiri::HTML.parse(open(url))
    end

    def headers
      query = '//h4/text()[preceding::h3[text()="Getting updates"]]'
      documentation.xpath(query)
                   .map(&:to_s)
                   .reject { |h| h.split.size > 1 }
    end

    def expected_types
      allowed_missing = %w(InlineQueryResult InputFile).freeze
      headers.select { |h| /^[[:upper:]]/.match(h) } - allowed_missing
    end

    def current_types
      ObjectSpace.each_object(Class)
                 .select { |klass| klass < Telegram::Bot::Types::Base }
                 .map { |type| type.name.split('::').last }
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def report(kind:, expected:, current:, indent: 0)
      items =
        case kind
        when :missing then expected - current
        when :extra then current - expected
        end
      return '' if items.empty?

      text = items.map do |i|
        "- #{i}".prepend(' ' * (indent + 1) * 2)
      end.join("\n")

      io = StringIO.new
      io.puts "#{kind.to_s.capitalize}:".prepend(' ' * indent * 2)
      io.puts text
      io.string
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def report_type_mismatch(expected:, current:, indent: 0)
      items = []
      substitutions = {
        'True' => 'Boolean'
      }
      expected.merge(current) do |attr_name, expected_type, current_type|
        substitution = substitutions.fetch(expected_type, expected_type)
        next if substitution == current_type
        items << {
          attribute: attr_name,
          expected_type: substitution,
          current_type: current_type
        }
      end
      return '' if items.empty?

      template = '- %{attr}: expect %{expected}, got %{current}'
      text = items.map do |i|
        format(
          template,
          attr:     i[:attribute],
          expected: i[:expected_type],
          current:  i[:current_type]
        ).prepend(' ' * (indent + 1) * 2)
      end.join("\n")

      io = StringIO.new
      io.puts 'Type mismatch:'.prepend(' ' * indent * 2)
      io.puts text
      io.string
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def print_report(r)
      return if r.empty?
      puts r
      puts
    end
  end
end
