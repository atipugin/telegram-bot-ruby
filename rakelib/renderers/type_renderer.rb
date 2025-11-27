# frozen_string_literal: true

require 'erb'

module Renderers
  # Renderer for Telegram Bot API type classes from parsed type attributes.
  #
  # This renderer automatically creates Ruby class content from the structured type
  # definitions in types.json. It converts JSON type specifications into
  # proper dry-types Ruby code and renders either regular type classes or union
  # type aliases.
  #
  # == Why This Renderer Exists
  #
  # After parsing the Telegram Bot API documentation (via TypesParser), we have
  # structured JSON data describing each type's fields, constraints, and metadata.
  # This renderer transforms that data into actual Ruby code that provides:
  # - Type validation using dry-types
  # - Proper attribute definitions with constraints
  # - Union type support for polymorphic fields
  # - Consistent code formatting across all type files
  #
  # == Input Format
  #
  # The generator expects type attributes in the following structure:
  #
  #   # Regular type with fields:
  #   {
  #     "TypeName": {
  #       "field_name": {
  #         "type": "string",
  #         "required": true,
  #         "default": "value",
  #         "min_size": 1,
  #         "max_size": 100
  #       }
  #     }
  #   }
  #
  #   # Array type with items:
  #   {
  #     "field_name": {
  #       "type": "array",
  #       "items": "ItemType"
  #     }
  #   }
  #
  #   # Union type:
  #   {
  #     "UnionType": {
  #       "type": ["Type1", "Type2", "Type3"]
  #     }
  #   }
  #
  # == Output
  #
  # Generates Ruby files in lib/telegram/bot/types/ with one of two formats:
  #
  # === Regular Type Class
  #
  #   class TypeName < Base
  #     attribute :field_name, Types::String
  #     attribute? :optional_field, Types::Integer
  #   end
  #
  # === Union Type Alias
  #
  #   TypeName = (
  #     Type1 |
  #     Type2 |
  #     Type3
  #   )
  #
  # == Dry-Types Conversion
  #
  # The generator maps JSON type specifications to dry-types expressions:
  #
  # === Basic Types
  # - "string"  → Types::String
  # - "integer" → Types::Integer
  # - "boolean" → Types::Bool
  # - "number"  → Types::Float
  # - "array"   → Types::Array
  #
  # === Constraints
  # - min_size/max_size → .constrained(min_size: N, max_size: M)
  # - required_value    → .constrained(eql: value)
  # - default           → .default(value)
  #
  # === Array Items
  # - items: "Type"     → Types::Array.of(Type)
  # - Nested arrays     → Types::Array.of(Types::Array.of(Type))
  #
  # === Union Field Types
  # - ["integer", "string"] → Types::Integer | Types::String
  #
  # == Boolean Normalization
  #
  # Special handling for boolean types:
  # - Types::Boolean.default(true)  → Types::True (always-true field)
  # - Types::Boolean                → Types::Bool (standard boolean)
  #
  # == Usage
  #
  #   types = JSON.parse(File.read('data/types.json'), symbolize_names: true)
  #
  #   types.each_pair do |name, attributes|
  #     renderer = Renderers::TypeRenderer.new(name, attributes)
  #     content = renderer.render
  #     # Write content to appropriate file...
  #   end
  #
  # @see DocsParsers::TypesParser For the parser that generates types.json
  class TypeRenderer # rubocop:disable Metrics/ClassLength
    # Dry-types built-in type names that map directly to Types::Xxx
    DRY_TYPES = %w[string integer float decimal array hash symbol boolean date date_time time range].freeze

    # Module prefix for dry-types type references
    TYPES_MODULE = 'Types'

    # Directory containing ERB templates
    TEMPLATES_DIR = File.expand_path('../templates', __dir__)

    # @return [String] The type name (e.g., "Animation", "User")
    attr_reader :name

    # @return [Hash] The type attributes from types.json
    attr_reader :attributes

    # Creates a new type renderer.
    #
    # @param name [String, Symbol] The type name (e.g., "Animation")
    # @param attributes [Hash] The type attributes from types.json
    #   For regular types, this is a hash of field_name => properties.
    #   For union types, this has a single :type key with an array of type names.
    #
    # @example Regular type
    #   TypeRenderer.new('User', {
    #     id: { type: 'integer', required: true },
    #     first_name: { type: 'string', required: true }
    #   })
    #
    # @example Union type
    #   TypeRenderer.new('MessageOrigin', {
    #     type: ['MessageOriginUser', 'MessageOriginHiddenUser']
    #   })
    def initialize(name, attributes)
      @name = name.to_s
      @attributes = attributes
    end

    # Renders the type file content as a string.
    #
    # For regular types, uses the type.erb template to render a class.
    # For union types, uses the empty_type.erb template to render a type alias.
    #
    # @return [String] The rendered type file content
    def render
      if union_type?
        render_union_type
      else
        render_class_type
      end
    end

    private

    # Checks if this type is a union type (type alias for multiple types).
    #
    # Union types have a :type key that is an Array of type names,
    # representing "one of" several possible types.
    #
    # @return [Boolean] true if this is a union type
    def union_type?
      attributes[:type].is_a?(Array)
    end

    # Renders a union type alias file content.
    #
    # Creates a type constant that's an OR of multiple types:
    #   TypeName = (Type1 | Type2 | Type3)
    #
    # @return [String] The rendered union type content
    def render_union_type
      attributes_str = attributes[:type].join(" |\n        ")
      render_erb_template('empty_type.erb', name: name, attributes: attributes_str)
    end

    # Renders a regular class type file content.
    #
    # Creates a class inheriting from Base with attribute definitions:
    #   class TypeName < Base
    #     attribute :field, Types::String
    #   end
    #
    # @return [String] The rendered class type content
    def render_class_type
      processed_attributes = build_all_attributes
      render_erb_template('type.erb', name: name, attributes: processed_attributes)
    end

    # Builds dry-types expressions for all attributes in this type.
    #
    # @return [Hash{Symbol => Hash}] Processed attributes with :type and :required keys
    #   Each value has:
    #   - :type [String] The dry-types type expression
    #   - :required [Boolean] Whether the attribute is required
    def build_all_attributes
      attributes.transform_values do |properties|
        {
          type: build_type_expression(properties),
          required: properties[:required]
        }
      end
    end

    # Builds a complete dry-types expression for a single attribute.
    #
    # Applies the following transformations in order:
    # 1. Resolve base type(s) to dry-types references
    # 2. Apply array item types if applicable
    # 3. Apply required value constraint if specified
    # 4. Apply size constraints if specified
    # 5. Apply default value if specified
    # 6. Normalize boolean type names
    #
    # @param properties [Hash] The attribute properties
    # @option properties [String, Array<String>] :type The type name(s)
    # @option properties [String, Hash] :items Array item type specification
    # @option properties [Boolean] :required Whether the field is required
    # @option properties [Object] :required_value Constant value constraint
    # @option properties [Object] :default Default value
    # @option properties [Integer] :min_size Minimum size constraint
    # @option properties [Integer] :max_size Maximum size constraint
    #
    # @return [String] The complete dry-types expression
    #
    # @example Simple type
    #   build_type_expression({ type: 'string' })
    #   #=> "Types::String"
    #
    # @example Array with items
    #   build_type_expression({ type: 'array', items: 'User' })
    #   #=> "Types::Array.of(User)"
    #
    # @example With constraints
    #   build_type_expression({ type: 'string', min_size: 1, max_size: 32 })
    #   #=> "Types::String.constrained(min_size: 1, max_size: 32)"
    def build_type_expression(properties)
      @current_properties = properties
      @original_type = properties[:type]

      type_str = build_base_type
      type_str = apply_array_items(type_str)
      type_str = apply_required_value_constraint(type_str)
      type_str = apply_size_constraints(type_str)
      type_str = apply_default_value(type_str)
      normalize_boolean_type(type_str)
    end

    # Builds the base type expression, handling union types.
    #
    # For single types, resolves to dry-types reference.
    # For union types (array of types), creates OR expression.
    #
    # @return [String] The base type expression
    #
    # @example Single type
    #   # With @original_type = "string"
    #   build_base_type #=> "Types::String"
    #
    # @example Union type
    #   # With @original_type = ["integer", "string"]
    #   build_base_type #=> "Types::Integer | Types::String"
    def build_base_type
      if @original_type.is_a?(Array)
        @original_type.map { |t| resolve_type_name(t) }.join(' | ')
      else
        resolve_type_name(@original_type)
      end
    end

    # Resolves a single type name to its dry-types equivalent.
    #
    # @param type_name [String] The type name from JSON (e.g., "string", "User")
    # @return [String] The dry-types type reference
    #
    # @example Built-in type
    #   resolve_type_name("string") #=> "Types::String"
    #
    # @example Number type (special case)
    #   resolve_type_name("number") #=> "Types::Float"
    #
    # @example Custom type
    #   resolve_type_name("User") #=> "User"
    def resolve_type_name(type_name)
      return "#{TYPES_MODULE}::Float" if type_name == 'number'

      if DRY_TYPES.include?(type_name)
        "#{TYPES_MODULE}::#{type_name.capitalize}"
      else
        type_name
      end
    end

    # Applies array item type specification (.of(...)).
    #
    # Handles both simple item types and nested arrays.
    #
    # @param type_str [String] The current type expression
    # @return [String] Type expression with .of() applied if applicable
    #
    # @example Simple items
    #   # With items: "User"
    #   apply_array_items("Types::Array") #=> "Types::Array.of(User)"
    #
    # @example Nested array
    #   # With items: { type: "array", items: "Button" }
    #   apply_array_items("Types::Array") #=> "Types::Array.of(Types::Array.of(Button))"
    def apply_array_items(type_str)
      items = @current_properties[:items]
      return type_str unless items

      if items.is_a?(String)
        "#{type_str}.of(#{resolve_type_name(items)})"
      elsif items[:type] == 'array'
        "#{type_str}.of(Types::Array.of(#{items[:items]}))"
      else
        type_str
      end
    end

    # Applies required value constraint (.constrained(eql: ...)).
    #
    # Used for discriminator fields that must have a specific constant value.
    #
    # @param type_str [String] The current type expression
    # @return [String] Type expression with equality constraint if applicable
    #
    # @example
    #   # With required_value: "solid"
    #   apply_required_value_constraint("Types::String")
    #   #=> "Types::String.constrained(eql: 'solid')"
    def apply_required_value_constraint(type_str)
      return type_str unless @current_properties[:required_value]

      value = typecast_value(@original_type, @current_properties[:required_value])
      "#{type_str}.constrained(eql: #{value})"
    end

    # Applies min/max size constraints (.constrained(min_size: ..., max_size: ...)).
    #
    # @param type_str [String] The current type expression
    # @return [String] Type expression with size constraints if applicable
    #
    # @example
    #   # With min_size: 1, max_size: 32
    #   apply_size_constraints("Types::String")
    #   #=> "Types::String.constrained(min_size: 1, max_size: 32)"
    def apply_size_constraints(type_str)
      min_size = @current_properties[:min_size]
      max_size = @current_properties[:max_size]
      return type_str unless min_size || max_size

      constraints = []
      constraints << "min_size: #{min_size}" if min_size
      constraints << "max_size: #{max_size}" if max_size

      "#{type_str}.constrained(#{constraints.join(', ')})"
    end

    # Applies default value (.default(...)).
    #
    # @param type_str [String] The current type expression
    # @return [String] Type expression with default if applicable
    #
    # @example
    #   # With default: "image/jpeg"
    #   apply_default_value("Types::String")
    #   #=> "Types::String.default('image/jpeg')"
    def apply_default_value(type_str)
      return type_str unless @current_properties[:default]

      value = typecast_value(@original_type, @current_properties[:default])
      "#{type_str}.default(#{value})"
    end

    # Normalizes boolean type expressions to dry-types conventions.
    #
    # - Types::Boolean.default(true) becomes Types::True (always-true marker)
    # - Types::Boolean becomes Types::Bool (standard boolean type)
    #
    # @param type_str [String] The type expression to normalize
    # @return [String] Normalized type expression
    def normalize_boolean_type(type_str)
      if type_str == "#{TYPES_MODULE}::Boolean.default(true)"
        "#{TYPES_MODULE}::True"
      else
        type_str.gsub("#{TYPES_MODULE}::Boolean", "#{TYPES_MODULE}::Bool")
      end
    end

    # Converts a value to its Ruby literal representation for code generation.
    #
    # @param type [String, Array<String>] The type name(s)
    # @param value [Object] The value to convert
    # @return [String] Ruby literal representation suitable for generated code
    #
    # @example String value
    #   typecast_value("string", "hello") #=> "'hello'"
    #
    # @example Integer value
    #   typecast_value("integer", 42) #=> "42"
    def typecast_value(type, value)
      actual_type = type.is_a?(Array) ? type.first : type
      resolved = resolve_type_name(actual_type)

      if resolved == "#{TYPES_MODULE}::String"
        "'#{value}'"
      else
        value.to_s
      end
    end

    # Renders an ERB template with the given local variables.
    #
    # @param template_name [String] Template filename (e.g., "type.erb")
    # @param locals [Hash] Local variables to make available in the template
    # @return [String] Rendered template content
    def render_erb_template(template_name, **locals)
      template_path = File.join(TEMPLATES_DIR, template_name)
      template = ERB.new(File.read(template_path))

      binding_context = create_template_binding(locals)
      template.result(binding_context).gsub("      \n", '')
    end

    # Creates a clean binding with the given local variables for template rendering.
    #
    # Uses an isolated Object instance to avoid polluting the binding with
    # instance variables from this class.
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

    # Converts CamelCase to snake_case for filenames.
    #
    # @param camel_cased_word [String] The CamelCase string (e.g., "MessageOrigin")
    # @return [String] The snake_case string (e.g., "message_origin")
    #
    # @example
    #   underscore("InlineKeyboardButton") #=> "inline_keyboard_button"
    #   underscore("HTMLParser") #=> "html_parser"
    def underscore(camel_cased_word)
      camel_cased_word.to_s
                      .gsub('::', '/')
                      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                      .tr('-', '_')
                      .downcase
    end
  end
end
