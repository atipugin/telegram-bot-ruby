# frozen_string_literal: true

require 'yaml'

type_attributes = YAML.safe_load(
  File.read(File.expand_path('../../../support/type_attributes.yml', __dir__))
)

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

          it 'has correct optionality' do
            expect(klass_attribute&.required?).to eq(parsed_attribute['required'])
          end
        end
      end
    end
  end
end
