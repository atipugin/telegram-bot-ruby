# frozen_string_literal: true

require 'erb'

module Renderers
  # Renderer for Telegram Bot API endpoints module from parsed methods.
  #
  # This renderer creates the endpoints.rb content from the structured
  # method definitions in endpoints.json. It renders a Ruby module containing
  # a constant hash mapping API method names to their return types.
  #
  # == Input Format
  #
  # The renderer expects methods in the following structure:
  #
  #   {
  #     "getMe": "Types::User",
  #     "sendMessage": "Types::Message",
  #     "getUpdates": "Types::Array.of(Types::Update)"
  #   }
  #
  # == Output
  #
  # Renders Ruby code with the ENDPOINTS constant:
  #
  #   module Telegram
  #     module Bot
  #       class Api
  #         ENDPOINTS = {
  #           'getMe' => Types::User,
  #           'sendMessage' => Types::Message,
  #         }.freeze
  #       end
  #     end
  #   end
  #
  # == Usage
  #
  #   methods = JSON.parse(File.read('data/endpoints.json'))
  #   renderer = Renderers::EndpointsRenderer.new(methods)
  #   content = renderer.render
  #   # Write content to appropriate file...
  #
  # @see DocsParsers::MethodsParser For the parser that generates endpoints.json
  class EndpointsRenderer
    # Directory containing ERB templates
    TEMPLATES_DIR = File.expand_path('../templates', __dir__)

    # @return [Hash] The methods hash from endpoints.json
    attr_reader :methods

    # Creates a new endpoints renderer.
    #
    # @param methods [Hash] The methods hash from endpoints.json
    #   Keys are method names (e.g., "getMe"), values are return types (e.g., "Types::User")
    #
    # @example
    #   EndpointsRenderer.new({
    #     'getMe' => 'Types::User',
    #     'sendMessage' => 'Types::Message'
    #   })
    def initialize(methods)
      @methods = methods.sort.to_h
    end

    # Renders the endpoints file content as a string.
    #
    # @return [String] The rendered endpoints file content
    def render
      render_erb_template('endpoints.erb', methods: methods)
    end

    private

    # Renders an ERB template with the given local variables.
    #
    # @param template_name [String] Template filename (e.g., "endpoints.erb")
    # @param locals [Hash] Local variables to make available in the template
    # @return [String] Rendered template content
    def render_erb_template(template_name, **locals)
      template_path = File.join(TEMPLATES_DIR, template_name)
      template = ERB.new(File.read(template_path))

      binding_context = create_template_binding(locals)
      template.result(binding_context)
    end

    # Creates a clean binding with the given local variables for template rendering.
    #
    # @param locals [Hash] Variables to expose in the binding
    # @return [Binding] A binding with the locals as methods
    def create_template_binding(locals)
      obj = Object.new
      locals.each do |key, value|
        obj.instance_variable_set("@#{key}", value)
        obj.define_singleton_method(key) { instance_variable_get("@#{key}") }
      end
      obj.instance_eval { binding }
    end
  end
end
