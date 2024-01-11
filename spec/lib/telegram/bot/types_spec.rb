# frozen_string_literal: true

require 'yaml'

type_attributes = YAML.safe_load File.read("#{__dir__}/../../../support/type_attributes.yml")

RSpec.describe Telegram::Bot::Types do
  type_attributes.each do |parsed_type, parsed_attributes|
    describe parsed_type do
      subject(:klass) { described_class.const_get(parsed_type, false) }

      it 'has correct attributes' do
        expect(klass.schema.keys.map(&:name)).to eq(parsed_attributes.map { |e| e['name'].to_sym })
      end

      parsed_attributes.each do |parsed_attribute|
        describe "##{parsed_attribute['name']}" do
          subject(:klass_attribute) { klass.schema.name_key_map[parsed_attribute['name'].to_sym] }

          describe 'type' do
            subject do
              klass_attribute_type = klass_attribute&.type

              ## We need to get rid of `default` values
              ## https://discourse.dry-rb.org/t/how-to-remove-a-default-from-dry-types-custom-class-attribute/1727
              klass_attribute_type = klass_attribute_type.type if klass_attribute_type.default?

              klass_attribute_type
            end

            def parse_string_type(type_string)
              if (match_data = type_string.match(/^Array of (?<inner_type>.+)$/))
                ## Call a recursion for `Array of Array of Something`
                return described_class::Array.of(send(__method__, match_data[:inner_type]))
              end

              ## We have no examples of `or` with 3 or more types
              if (match_data = type_string.match(/^(\w+) or (\w+)$/))
                ## `uniq` for `InputFile`, for example
                return match_data[1..].map { |matched_type| send(__method__, matched_type) }.uniq.reduce(:|)
              end

              type_string =
                case type_string
                ## `dry-types` has no `Boolean` type (or alias)
                when 'Boolean' then 'Bool'
                when 'Float number' then 'Float'
                ## It's a `file_id`, URL or `multipart/form-data`:
                ## https://core.telegram.org/bots/api#inputfile
                when 'InputFile' then 'String'
                ## I'm not sure about this. It's like "True is optional to send" and "We can response with False"
                # when 'True' && !parsed_attribute['required'] then 'Boolean'
                else type_string
                end

              # binding.irb if type_string == 'Bool'

              ## Without `false` for `const_get` because base types inhereted from the `dry-types`
              described_class.const_get(type_string)
            end

            let(:expected_type) do
              result = parse_string_type(parsed_attribute['type'])

              ## Sometimes there are required values for attributes, like `BotCommandScope` or `MenuButton`
              if (required_value = parsed_attribute['required_value'])
                result = result.constrained(eql: required_value)
              end

              result
            end

            it { is_expected.to eq expected_type }
          end

          describe 'optionality' do
            subject { klass_attribute&.required? }

            it { is_expected.to eq parsed_attribute['required'] }
          end
        end
      end
    end
  end
end
