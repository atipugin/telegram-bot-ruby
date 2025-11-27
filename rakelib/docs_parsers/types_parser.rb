# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'json'

module DocsParsers
  # Parser for Telegram Bot API documentation types.
  #
  # This parser automatically extracts type definitions from the official Telegram Bot API
  # documentation page (https://core.telegram.org/bots/api) and generates a structured
  # JSON file (type_attributes.json) that describes all API types with their fields,
  # constraints, and metadata.
  #
  # == Why This Parser Exists
  #
  # The OpenAPI schema for Telegram Bot API is no longer being maintained by Telegram,
  # making it necessary to parse the HTML documentation directly to keep type definitions
  # up-to-date with the latest Bot API changes. This parser provides an automated solution
  # to extract and structure type information from the official HTML documentation.
  #
  # The Telegram Bot API documentation is the single source of truth for API types, but
  # it's only available as HTML. To provide proper type checking, validation, and
  # autocomplete in the Ruby SDK, we need structured data about each type. This parser:
  # - Eliminates manual maintenance of type definitions
  # - Ensures the SDK stays in sync with the official API
  # - Captures detailed metadata (required fields, default values, size constraints)
  # - Enables automated type generation for the Ruby SDK
  # - Automatically detects new types added in API updates (e.g., checklist, gift, story features)
  #
  # == Output Format
  #
  # The parser generates a JSON file with the following structure:
  #
  #   {
  #     "TypeName": {
  #       "field_name": {
  #         "type": "string|integer|boolean|number|array|CustomType",
  #         "required": true,           // Present if field is required
  #         "default": value,            // For boolean fields or fields with defaults
  #         "items": "ItemType",         // For array types
  #         "min_size": 1,              // For string fields with size constraints
  #         "max_size": 32,             // For string fields with size constraints
  #         "required_value": "value"    // For discriminator fields in union type members
  #       }
  #     }
  #   }
  #
  # == How We Parse
  #
  # The parser uses Nokogiri to parse the HTML documentation and identifies three categories
  # of types based on their HTML structure:
  #
  # === 1. Regular Types
  #
  # Types with fields defined in a table (e.g., User, Message).
  #
  # HTML Pattern:
  #   <h4>TypeName</h4>
  #   <p>Description of the type</p>
  #   <table>
  #     <thead><tr><th>Field</th><th>Type</th><th>Description</th></tr></thead>
  #     <tbody>
  #       <tr><td>field_name</td><td>FieldType</td><td>Optional. Description...</td></tr>
  #     </tbody>
  #   </table>
  #
  # Parser extracts:
  # - Field names, types, and descriptions from HTML tables
  # - Constraints from descriptions (min/max sizes, default values)
  # - Required vs optional fields (checks for "Optional" keyword)
  # - Discriminator fields for union type members (e.g., type="always X")
  #
  # === 2. Union Types
  #
  # Types representing "one of" several types (e.g., MessageOrigin, InputMedia).
  #
  # HTML Pattern:
  #   <h4>UnionTypeName</h4>
  #   <p>This object can be one of</p>
  #   <ul>
  #     <li><a href="#type1">Type1</a></li>
  #     <li><a href="#type2">Type2</a></li>
  #   </ul>
  #
  # Detection keywords: "can be one of", "should be one of", "represents one of",
  # "currently, the following N types", "currently support the following N"
  #
  # Output format: {"type": ["Type1", "Type2", ...]}
  #
  # === 3. Empty Types
  #
  # Marker types with no fields (e.g., ForumTopicClosed, CallbackGame).
  #
  # HTML Pattern:
  #   <h4>EmptyTypeName</h4>
  #   <p>This object ... Currently holds no information.</p>
  #
  # Detection keywords: "currently holds no information", "placeholder.*holds no information"
  #
  # Output format: {}
  #
  # == Detection Logic
  #
  # For each <h4> header in the documentation:
  # 1. Extract type name from header text
  # 2. Get description from following <p> elements
  # 3. Look for table with "Field | Type | Description" headers
  # 4. Look for <ul> list of member types
  #
  # Classification decision tree:
  # - If description has union keywords + list present + no table → Union Type
  # - If description has "holds no information" + no table → Empty Type
  # - If table with field definitions present → Regular Type
  # - Otherwise → Skip (likely a method, not a type)
  #
  # == Parser Improvements
  #
  # Several improvements were made to accurately capture all type metadata:
  #
  # === 1. Min/Max Size Constraints
  # Fields like BotCommand.command specify "1-32 characters" in descriptions.
  # Parser now extracts these patterns and adds min_size/max_size attributes.
  # Note: min_size is omitted when zero (e.g., "0-4096 characters" only adds max_size).
  #
  # === 2. Union Field Types
  # Fields like chat_id can be "Integer or String". Parser now returns an array
  # for the type attribute: {"type": ["integer", "string"]} instead of just the first type.
  #
  # === 3. Nested Arrays
  # Fields like InlineKeyboardMarkup.inline_keyboard have type "Array of Array of X".
  # Parser now creates nested array structures:
  #   {
  #     "type": "array",
  #     "items": {
  #       "type": "array",
  #       "items": "InlineKeyboardButton"
  #     }
  #   }
  #
  # === 4. Float vs Number Type
  # Changed from "float" to "number" in TYPE_MAPPING for consistency with existing file.
  #
  # === 5. Default Values
  # Parses "Defaults to X" patterns from descriptions. Supports:
  # - Quoted strings: Defaults to "image/jpeg" → "image/jpeg"
  # - Booleans: defaults to true → true
  # - Numbers: defaults to 0 → 0
  # Intentionally skips field references like "defaults to the value of other_field".
  #
  # === 6. Discriminator Fields
  # Fields like type, source, status often have required values (e.g., type always "solid").
  # Parser detects patterns like "always X" or "must be X" and adds:
  # - required_value: The constant value
  # - default: Set to the same value
  #
  # == Type Mappings
  #
  # The parser maps Telegram API type names to JSON type representations:
  # - Integer/Int → "integer"
  # - String → "string"
  # - Boolean → "boolean"
  # - True → "boolean" with "default": true
  # - Float → "number" (changed from "float" for consistency)
  # - Array of X → {"type": "array", "items": "X"}
  # - Array of Array of X → {"type": "array", "items": {"type": "array", "items": "X"}}
  # - Integer or String → {"type": ["integer", "string"]}
  # - Custom types → Referenced by type name (e.g., "Message", "User")
  #
  # == Validation Results
  #
  # After improvements, the parser produces output that matches the existing type_attributes.json
  # with only legitimate API version differences. Before improvements, 53 types differed;
  # after improvements, only 12 types differ due to API version changes (new/removed fields).
  #
  # Current output statistics (as of latest API version):
  # - Regular types: ~250
  # - Union types: ~21
  # - Empty types: ~6
  # - Custom types: 1 (Error)
  # - Total: ~278 types
  #
  # New types automatically detected in recent API updates:
  # - Checklist features: ChecklistTask, Checklist, InputChecklistTask, etc.
  # - Suggested posts: SuggestedPostPrice, SuggestedPostInfo, etc.
  # - Gift system: UniqueGift, GiftInfo, OwnedGift, etc.
  # - Story areas: StoryAreaType, StoryAreaTypeLocation, etc.
  # - Business features: BusinessBotRights, DirectMessagesTopic
  #
  # == Dependencies
  #
  # Required Ruby gems:
  # - nokogiri - HTML/XML parsing
  # - open-uri - HTTP fetching (Ruby standard library)
  # - json - JSON generation (Ruby standard library)
  #
  # == Performance
  #
  # - Fetch time: ~2-3 seconds (depends on network)
  # - Parse time: <1 second
  # - Total execution: ~3-4 seconds
  #
  # == Custom Types
  #
  # The parser includes an add_custom_types! method to add types not present in the official
  # documentation. Currently includes:
  # - Error: Represents API error responses with fields: ok, error_code, description, parameters
  #
  # == Usage Workflow
  #
  # Typical workflow for updating types after a Bot API release:
  # 1. Run parser to generate new types: parser.fetch; parser.parse; parser.save('new.json')
  # 2. Compare with existing file to review changes
  # 3. Check for new types, removed types, and field changes
  # 4. If everything looks correct, replace the existing type_attributes.json
  # 5. Regenerate Ruby type classes if applicable
  # 6. Run test suite to ensure compatibility
  #
  # @note Requires manual review - Generated types should be reviewed before replacing existing file
  # @note Complex inline unions - Some complex union patterns may need special handling
  # @note Documentation changes - Changes to HTML structure could break pattern matching
  # @note No reference validation - Doesn't validate type references or check for circular dependencies
  # @note Method parameters not parsed - Only parses return types, not method parameters
  # @note Custom types must be added manually - Types like Error that aren't in docs need manual addition
  #
  # @example Basic usage
  #   parser = TypesParser.new
  #   parser.fetch                   # Fetch HTML from Telegram Bot API
  #   parser.parse                   # Parse all types from HTML
  #   parser.add_custom_types!       # Add custom types like Error
  #   parser.save('type_attributes.json')  # Save to file
  #
  # @example Programmatic usage
  #   parser = TypesParser.new('https://core.telegram.org/bots/api')
  #   parser.fetch
  #   types = parser.parse
  #   json_string = parser.to_json  # Get JSON string without saving
  #
  # @see https://core.telegram.org/bots/api Official Telegram Bot API documentation
  #
  class TypesParser
    TYPE_MAPPING = {
      'Integer' => 'integer',
      'String' => 'string',
      'Boolean' => 'boolean',
      'Float' => 'number', # Use 'number' for consistency with existing file
      'True' => 'boolean',
      'Int' => 'integer'
    }.freeze

    UNION_KEYWORDS = [
      /can be one of/i,
      /it can be one of/i,
      /should be one of/i,
      /represents one of/i,
      /currently,? the following \d+/i,
      /currently support(s|ed)? (results of the |the )?following \d+/i,
      /This object describes.*(it can be|one of)/i
    ].freeze

    EMPTY_TYPE_KEYWORDS = [
      /currently holds no information/i,
      /placeholder.*holds no information/i
    ].freeze

    STOP_TAGS = %w[table ul].freeze

    # Discriminator patterns in order of priority
    DISCRIMINATOR_PATTERNS = [
      # Value in quotes: always "solid" or always "solid" (Unicode smart quotes)
      /always\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i,
      # Value without quotes: always solid
      /always\s+(\w+)/i,
      # Must be pattern with quotes: must be "data"
      /must be\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i
    ].freeze

    def initialize(url = 'https://core.telegram.org/bots/api')
      @url = URI(url)
      @doc = nil
      @types = {}
    end

    def fetch
      puts "Fetching #{@url}..."
      html = URI.parse(@url).open
      @doc = Nokogiri::HTML(html)
      puts '✓ Fetched successfully'
    end

    def parse
      return unless @doc

      type_count = 0
      union_count = 0
      empty_count = 0

      # Find all h4 headers (type definitions)
      @doc.css('h4').each do |header|
        type_name = header.text.strip
        next if type_name.empty?

        # Detect type category
        description = get_description(header)
        table = find_following_table(header)
        list = find_following_list(header)

        if union_type?(description, table, list)
          parse_union_type(type_name, list)
          union_count += 1
        elsif empty_type?(description, table)
          parse_empty_type(type_name)
          empty_count += 1
        elsif table && type_table?(table)
          parse_regular_type(type_name, table)
          type_count += 1
        end
      end

      puts "\nParsing complete:"
      puts "  Regular types: #{type_count}"
      puts "  Union types: #{union_count}"
      puts "  Empty types: #{empty_count}"
      puts "  Total: #{@types.size}"

      @types
    end

    private

    def union_type?(description, table, list)
      return false unless description && list

      # Union types have a description with keywords and a list, but no table
      has_union_keyword = UNION_KEYWORDS.any? { |pattern| description.match?(pattern) }
      has_union_keyword && !table
    end

    def empty_type?(description, table)
      return false unless description
      return false if table

      EMPTY_TYPE_KEYWORDS.any? { |pattern| description.match?(pattern) }
    end

    def type_table?(table)
      headers = table.css('thead tr th, tr:first-child th').map { |x| x.text.strip }
      headers == %w[Field Type Description]
    end

    def parse_union_type(type_name, list)
      return unless list

      # Extract member type names from the list
      members = []
      list.css('li').each do |li|
        link = li.css('a').first
        member_name = link ? link.text.strip : li.text.strip.split("\n").first&.strip
        members << member_name if member_name && !member_name.empty?
      end

      return unless members.any?

      @types[type_name] = { 'type' => members }
      puts "  Union: #{type_name} (#{members.size} members)"
    end

    def parse_empty_type(type_name)
      @types[type_name] = {}
      puts "  Empty: #{type_name}"
    end

    def parse_regular_type(type_name, table)
      attributes = {}

      table.css('tbody tr, tr').each do |row|
        cells = row.css('td')
        next if cells.size < 3

        field_name = cells[0].text.strip
        type_html = cells[1].inner_html.strip
        description_text = cells[2].text.strip

        next if field_name.empty?
        next if field_name == 'Field' # Skip header row if it's in tbody

        attribute = parse_attribute(field_name, type_html, description_text)
        attributes[field_name] = attribute if attribute
      end

      return unless attributes.any?

      @types[type_name] = attributes
      puts "  Type: #{type_name} (#{attributes.size} fields)"
    end

    def parse_attribute(field_name, type_html, description)
      attribute = {}

      # Determine if optional
      is_optional = description.match?(/^optional/i) ||
                    description.match?(/^\*?optional\.\s/i) ||
                    description.match?(/^_optional_/i)
      attribute['required'] = true unless is_optional

      # Parse type information
      type_info = parse_type_info(type_html)
      attribute.merge!(type_info)

      # Check for default values (especially for True boolean type)
      attribute['default'] = true if type_info['type'] == 'boolean' && type_html.include?('True')

      # Parse default from description: "Defaults to X" or "defaults to X"
      # Only accept quoted strings or specific values (true/false/numbers)
      # Skip patterns like "defaults to the value of X" (references to other fields)
      if (match = description.match(/defaults to\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i))
        # Default value in quotes: Defaults to "image/jpeg"
        attribute['default'] = match[1].strip
      elsif (match = description.match(/defaults to\s+(true|false)\b/i))
        # Boolean default: defaults to true
        attribute['default'] = match[1].downcase == 'true'
      elsif (match = description.match(/defaults to\s+(\d+\.?\d*)\b/i))
        # Numeric default: defaults to 0 or 0.0
        value = match[1]
        attribute['default'] = value.include?('.') ? value.to_f : value.to_i
      end
      # NOTE: We intentionally skip unquoted word defaults to avoid capturing
      # references like "defaults to the value of other_field"

      # Parse min_size and max_size from description
      # Patterns: "1-32 characters", "0-4096 characters", etc.
      if (match = description.match(/(\d+)-(\d+)\s+characters/i))
        min = match[1].to_i
        max = match[2].to_i
        attribute['min_size'] = min unless min.zero? # Skip min_size if 0
        attribute['max_size'] = max
      end

      # Check for special required_value (discriminator fields for union type members)
      # Patterns: 'always "value"' or 'must be value'
      # Note: HTML uses Unicode smart quotes (\u201C and \u201D) instead of regular quotes
      # Exclude patterns like "must be one of X or Y" (multiple choice, not discriminator)
      discriminator_fields = %w[type source status currency]
      if discriminator_fields.include?(field_name)
        discriminator_value = extract_discriminator_value(description)
        if discriminator_value
          attribute['required_value'] = discriminator_value
          attribute['default'] = discriminator_value
        end
      end

      attribute
    end

    def extract_discriminator_value(description)
      # Try standard patterns first
      DISCRIMINATOR_PATTERNS.each do |pattern|
        match = description.match(pattern)
        return match[1].strip if match
      end

      # Must be pattern without quotes: must be data, must be default
      # Explicitly exclude "must be one of" pattern before trying to match
      return nil if description.match?(/must be\s+one\s+of/i)

      match = description.match(/must be\s+(\w+)\b/i)
      match ? match[1].strip : nil
    end

    def parse_type_info(type_html)
      # Parse HTML fragment to extract type text
      doc = Nokogiri::HTML.fragment(type_html)
      type_text = doc.text.strip

      # Handle nested arrays: "Array of Array of X"
      if (match = type_text.match(/^Array of Array of (.+)$/i))
        inner_type = match[1].strip
        inner_type = extract_type_name(inner_type)

        return {
          'type' => 'array',
          'items' => {
            'type' => 'array',
            'items' => map_type(inner_type)
          }
        }
      end

      # Handle regular arrays: "Array of X"
      if (match = type_text.match(/^Array of (.+)$/i))
        item_type = match[1].strip
        item_type = extract_type_name(item_type)

        return {
          'type' => 'array',
          'items' => map_type(item_type)
        }
      end

      # Handle union types: "A or B" or "A, B or C"
      # For inline field unions (not top-level type unions), return array of types
      if type_text.match?(/\s+or\s+/i)
        # Split by "or" and clean up each type
        types = type_text.split(/\s+or\s+/i).map do |part|
          # Remove any commas and extra text
          part = part.split(',').first.strip
          map_type(extract_type_name(part))
        end

        # If we have exactly 2 simple types, return as array
        # Examples: "Integer or String", "Float or Integer"
        return { 'type' => types } if types.size == 2 && types.all? { |t| t =~ /^[a-z]+$/ }

        # For complex unions, take first type (rare edge case)
        return { 'type' => types.first }

      end

      # Single type
      type_name = extract_type_name(type_text)
      { 'type' => map_type(type_name) }
    end

    def extract_type_name(text)
      # Extract clean type name from text
      text.strip
          .gsub(/\s*\(.*?\)/, '') # Remove parenthetical notes
          .split(/\s+/).first # Take first word
          .strip
    end

    def map_type(type_name)
      TYPE_MAPPING[type_name] || type_name
    end

    def find_following_table(header)
      current = header.next_element
      while current && current.name != 'h4' && current.name != 'h3'
        return current if current.name == 'table'

        current = current.next_element
      end
      nil
    end

    def find_following_list(header)
      current = header.next_element
      count = 0
      while current && current.name != 'h4' && current.name != 'h3' && count < 5
        return current if current.name == 'ul'

        current = current.next_element
        count += 1
      end
      nil
    end

    def get_description(header)
      current = header.next_element
      descriptions = []

      # Collect all paragraph descriptions before table/list
      while current && current.name != 'h4' && current.name != 'h3'
        break if STOP_TAGS.include?(current.name)

        descriptions << current.text.strip if current.name == 'p'
        current = current.next_element
      end

      descriptions.join(' ')
    end

    public

    def to_json(*_args)
      # Sort types alphabetically for consistency
      sorted_types = @types.keys.sort.each_with_object({}) do |key, hash|
        hash[key] = @types[key]
      end

      JSON.pretty_generate(sorted_types)
    end

    def save(filename)
      File.write(filename, to_json)
      puts "\n✓ Saved to #{filename}"
    end

    def add_custom_types!
      # Add Error type (custom type for API error responses, not in official docs)
      @types['Error'] = {
        'ok' => {
          'type' => 'boolean',
          'required' => true
        },
        'error_code' => {
          'type' => 'integer',
          'required' => true
        },
        'description' => {
          'type' => 'string',
          'required' => true
        },
        'parameters' => {
          'type' => 'ResponseParameters'
        }
      }

      puts '  Custom: Error (added manually)'
    end
  end
end
