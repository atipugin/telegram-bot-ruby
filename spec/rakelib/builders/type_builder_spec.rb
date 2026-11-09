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

  describe '#build for object types' do
    subject(:output) { builder.build }

    let(:type_name) { 'InputRichMessageMedia' }
    let(:types) { { type_name => attributes } }
    let(:attributes) { { media: { type: members, required: true } } }

    context 'with a union that fits on one line' do
      let(:members) { %w[InputMediaPhoto InputMediaVideo] }

      it 'keeps it on the attribute line' do
        expect(output).to include('attribute :media, InputMediaPhoto | InputMediaVideo')
      end
    end

    context 'with a union longer than a line' do
      let(:members) do
        %w[InputMediaAnimation InputMediaAudio InputMediaDocument InputMediaPhoto InputMediaVideo InputMediaVoiceNote]
      end

      it 'puts one member per line, aligned after the attribute name' do
        expect(output).to include(
          "attribute :media, InputMediaAnimation |\n                          InputMediaAudio |\n"
        )
      end

      it 'keeps every line within the limit' do
        expect(output.lines.map { |line| line.chomp.length }.max).to be <= 120
      end
    end
  end
end
