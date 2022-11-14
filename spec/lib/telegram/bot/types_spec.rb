# frozen_string_literal: true

require 'yaml'

type_attributes = YAML.safe_load(
  File.read(File.expand_path('../../../fixtures/type_attributes.yml', __dir__))
)

RSpec.describe Telegram::Bot::Types do
  type_attributes.each do |type, attributes|
    describe type do
      subject(:klass) { Object.const_get("Telegram::Bot::Types::#{type}") }

      it 'has correct attributes' do
        expect(klass.schema.keys.map(&:name)).to eq(attributes.map { |e| e['name'].to_sym })
      end

      attributes.each do |attribute|
        describe "##{attribute['name']}" do
          it 'has correct optionality' do
            expect(klass.schema.name_key_map[attribute['name'].to_sym].required?).to eq(attribute['required'])
          end
        end
      end
    end
  end
end
