# frozen_string_literal: true

require 'json'
require 'erb'

desc 'Rebuild endpoints from methods.json'
task :rebuild_methods do
  methods_file = "#{__dir__}/../data/methods.json"

  unless File.exist?(methods_file)
    puts "Error: #{methods_file} not found. Run 'rake parse_methods' first."
    exit 1
  end

  methods = JSON.parse(File.read(methods_file))

  # Sort methods alphabetically for consistency
  methods = methods.sort.to_h

  output_file = "#{__dir__}/../lib/telegram/bot/api/endpoints.rb"
  File.write(output_file, ERB.new(File.read("#{__dir__}/templates/endpoints.erb")).result(binding))

  puts "✓ Rebuilt #{output_file}"
  puts "  Generated #{methods.size} endpoints"
end
