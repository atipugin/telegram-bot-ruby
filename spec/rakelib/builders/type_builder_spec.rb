# frozen_string_literal: true

require_relative '../../../rakelib/builders/type_builder'
require_relative '../../../rakelib/builders/type_dependencies'

RSpec.describe Builders::TypeBuilder do
  subject(:builder) do
    described_class.new(
      type_name,
      attributes,
      templates_dir: templates_dir,
      dependencies: dependencies
    )
  end

  let(:templates_dir) { File.expand_path('../../../rakelib/templates', __dir__) }
  let(:type_name) { 'RichText' }
  let(:attributes) { { type: members } }
  let(:members) { %w[string array:RichText RichTextBold] }
  let(:types) do
    {
      'RichText' => { type: members },
      'RichTextBold' => {
        type: { type: 'string', required: true, required_value: 'bold' },
        text: { type: 'string', required: true }
      }
    }
  end
  let(:dependencies) { Builders::TypeDependencies.new(types) }

  describe '#build with size constraints' do
    let(:type_name) { 'Example' }
    let(:attributes) { { items: { type: 'array', items: 'string', max_size: 32 } } }

    it 'preserves a maximum without a minimum' do
      expect(builder.build).to include('Types::Array.of(Types::String).constrained(max_size: 32)')
    end

    context 'with a minimum but no maximum' do
      let(:attributes) { { items: { type: 'array', items: 'string', min_size: 1 } } }

      it 'preserves a minimum without a maximum' do
        expect(builder.build).to include('Types::Array.of(Types::String).constrained(min_size: 1)')
      end
    end
  end

  describe '#build for empty (sum) types' do
    subject(:output) { builder.build }

    it 'maps string members to Types::String first' do
      expect(output).to match(/RichText = \(\s*Types::String\s*\|/m)
    end

    it 'maps array:Name members to deferred Array.of' do
      expect(output).to include('Types::Array.of(Types.deferred(:RichText))')
    end

    it 'keeps struct member names as-is' do
      expect(output).to include("RichTextBold\n")
    end

    it 'emits a valid empty-type module shell' do
      expect(output).to match(/module Telegram\b.*\bRichText = \(.*\)/m)
    end

    context 'with only struct members' do
      let(:members) { %w[ChatMemberOwner ChatMemberAdministrator] }

      it 'joins struct members without string/array wrappers' do
        expect(output).to match(
          /ChatMemberOwner\s*\|\s*ChatMemberAdministrator\n/
        ).and(satisfy { |body| !body.include?('Types::String') && !body.include?('Types::Array') })
      end
    end
  end
end
