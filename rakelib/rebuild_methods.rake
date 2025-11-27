# frozen_string_literal: true

require 'json'

desc 'Rebuild endpoints from methods.json'
task :rebuild_methods do
  methods_file = "#{__dir__}/../data/methods.json"

  unless File.exist?(methods_file)
    puts "Error: #{methods_file} not found. Run 'rake parse_methods' first."
    exit 1
  end

  methods = JSON.parse(File.read(methods_file))

  # Sort methods alphabetically for consistency
  sorted_methods = methods.keys.sort.map do |method_name|
    return_type = methods[method_name]
    "        '#{method_name}' => #{return_type}"
  end

  content = <<~RUBY
    # frozen_string_literal: true

    module Telegram
      module Bot
        class Api
          ENDPOINTS = {
    #{sorted_methods.join(",\n")}
          }.freeze
        end
      end
    end
  RUBY

  output_file = "#{__dir__}/../lib/telegram/bot/api/endpoints.rb"
  File.write(output_file, content)

  puts "✓ Rebuilt #{output_file}"
  puts "  Generated #{methods.size} endpoints"
end
