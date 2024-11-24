# frozen_string_literal: true

require 'json'

file = File.read("#{__dir__}/../../../../data/type_attributes.json")
parsed_types = JSON.parse(file)

RSpec.describe Telegram::Bot::Types do
  parsed_types.each do |class_name, attributes|
    describe class_name do
      subject(:klass) { described_class.const_get(class_name, false) }

      # empty classes exception
      next if described_class.const_get(class_name, false).instance_of?(Dry::Struct::Sum)

      it 'has correct attributes' do
        expect(klass.schema.keys.map(&:name)).to eq(attributes.keys.map(&:to_sym))
      end
    end
  end
end
