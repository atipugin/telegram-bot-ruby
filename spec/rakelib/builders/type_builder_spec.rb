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

  describe '#build for size and range constraints' do
    subject(:output) do
      described_class.new(
        'Sized', { field: field },
        templates_dir: templates_dir, dependencies: dependencies
      ).build
    end

    let(:types) { { Sized: { field: field } } }

    context 'with a string length range' do
      let(:field) { { type: 'string', min_size: 1, max_size: 64 } }

      it { is_expected.to include('Types::String.constrained(min_size: 1, max_size: 64)') }
    end

    # This was dropped entirely: the old placeholder-substitution reset the
    # constraint to '' whenever min_size was absent, so max-only limits never
    # reached the generated file.
    context 'with only a maximum length' do
      let(:field) { { type: 'string', max_size: 200 } }

      it { is_expected.to include('Types::String.constrained(max_size: 200)') }
    end

    context 'with only a minimum length' do
      let(:field) { { type: 'string', min_size: 3 } }

      it { is_expected.to include('Types::String.constrained(min_size: 3)') }
    end

    # min_size on an Integer compares Integer#size, the byte width, which is 8
    # for every value -- so the constraint accepted everything.
    context 'with a numeric range' do
      let(:field) { { type: 'integer', min: 5, max: 100_000 } }

      it { is_expected.to include('Types::Integer.constrained(gteq: 5, lteq: 100_000)') }
    end

    context 'with no constraint at all' do
      let(:field) { { type: 'string' } }

      it { is_expected.not_to include('constrained') }
    end

    # max_size_parsed is measured on the text after markup is parsed, which
    # the client cannot compute, so it is recorded but never emitted.
    context 'with a maximum measured after entities parsing' do
      let(:field) { { type: 'string', min_size: 1, max_size_parsed: 255 } }

      it { is_expected.to include('Types::String.constrained(min_size: 1)') }

      it { is_expected.not_to include('255') }
    end
  end
end
