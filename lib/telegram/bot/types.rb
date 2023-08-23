# frozen_string_literal: true

module Telegram
  module Bot
    module Types
      include Dry.Types()

      types_dir = "#{__dir__}/types"
      Dir["#{types_dir}/**/*.rb"].each do |file_name|
        relative_file_path = Pathname.new(file_name).relative_path_from(types_dir).to_s.chomp('.rb')
        constant_name = relative_file_path.split('/').map { |part| part.split('_').map(&:capitalize).join }.join('::')
        autoload constant_name, file_name
      end
    end
  end
end

require_relative 'types/base'
